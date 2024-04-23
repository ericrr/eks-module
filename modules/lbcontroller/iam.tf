resource "aws_iam_policy" "kubernetes_alb_controller" {
  
  count       = local.lbcontroller.enabled ? 1 : 0
  name        = "${var.cluster_name}-alb-controller"
  path        = "/"
  description = "Policy for load balancer controller service"

  policy = file("${path.module}/iam/lbcontroller-policy.json")

#  depends_on  = [
#    var.mod_dependency
#    ]

}

# Role
data "aws_iam_policy_document" "kubernetes_alb_controller_assume" {
  count = local.lbcontroller.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${local.lbcontroller.namespace}:${local.lbcontroller.saname}",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "kubernetes_alb_controller" {
  count              = local.lbcontroller.enabled ? 1 : 0
  name               = "${var.cluster_name}-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_alb_controller_assume[0].json
}

resource "aws_iam_role_policy_attachment" "kubernetes_alb_controller" {
  count      = local.lbcontroller.enabled ? 1 : 0
  role       = aws_iam_role.kubernetes_alb_controller[0].name
  policy_arn = aws_iam_policy.kubernetes_alb_controller[0].arn
}