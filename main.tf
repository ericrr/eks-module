# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name.manager
  cluster_version = "1.27"

  enable_irsa = true
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-${local.cluster_name.manager}"

      instance_types = ["t3a.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    # two = {
    #   name = "node-group-2"

    #   instance_types = ["t3.small"]

    #   min_size     = 1
    #   max_size     = 2
    #   desired_size = 1
    # }
  }
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"

  }

  depends_on = [ module.eks ]

}

resource "aws_eks_addon" "vpc_cni" {
  addon_name   = "vpc-cni"
  cluster_name = module.eks.cluster_name

  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [ module.eks ]

}

resource "aws_ssm_parameter" "cluster_name" {
  name        = "/${var.environment}/eks/${local.cluster_name.manager}/cluster_name"
  description = "The parameter description EKS Cluster Name"
  type        = "String"
  value       = local.cluster_name.manager

  tags = {
    environment = "${var.environment}"
    module = "eks"
    cluster = "${local.cluster_name.manager}"
  }
}

resource "aws_ssm_parameter" "cluster_endpoint" {
  name        = "/${var.environment}/eks/${local.cluster_name.manager}/cluster_endpoint"
  description = "The parameter description EKS Cluster Endpoint"
  type        = "String"
  value       = module.eks.cluster_endpoint

  tags = {
    environment = "${var.environment}"
    module = "eks"
    cluster = "${local.cluster_name.manager}"
  }
}

resource "aws_ssm_parameter" "cluster_auth" {
  name        = "/${var.environment}/eks/${local.cluster_name.manager}/cluster_authority"
  description = "The parameter description EKS Cluster Authority"
  type        = "String"
  value       = base64decode(module.eks.cluster_certificate_authority_data)

  tags = {
    environment = "${var.environment}"
    module = "eks"
    cluster = "${local.cluster_name.manager}"
  }
}