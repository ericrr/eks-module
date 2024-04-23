
resource "helm_release" "alb_controller" {

  count      = local.lbcontroller.enabled ? 1 : 0

  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.6.2"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "awsRegion"
    value = "${data.aws_region.current.name}"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = local.lbcontroller.saname
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.kubernetes_alb_controller[0].arn
  }

  set {
    name  = "enableServiceMutatorWebhook"
    value = "false"
  }

  # depends_on = [
  #   var.mod_dependency, 
  #   kubernetes_namespace.alb_controller
  # ]

}