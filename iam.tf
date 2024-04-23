resource "aws_iam_role" "manager" {
  name = "eks-cluster-manager"
  tags = {
    tag-key = "eks-cluster-manager"
  }

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

# eks policy attachment

resource "aws_iam_role_policy_attachment" "manager-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.manager.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# try(replace(module.eks[0].identity[0].oidc[0].issuer, "https://", ""), null)

data "aws_iam_policy_document" "manager_cluster_autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "manager_cluster_autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.manager_cluster_autoscaler_assume_role_policy.json
  name               = "manager-cluster-autoscaler"
}

resource "aws_iam_policy" "manager_cluster_autoscaler" {
  name = "manager-cluster-autoscaler"

  policy = jsonencode({
    Statement = [{
      Action = [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "manager_cluster_autoscaler_attach" {
  role       = aws_iam_role.manager_cluster_autoscaler.name
  policy_arn = aws_iam_policy.manager_cluster_autoscaler.arn
}

output "manager_cluster_autoscaler_arn" {
  value = aws_iam_role.manager_cluster_autoscaler.arn
}