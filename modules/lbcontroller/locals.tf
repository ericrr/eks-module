
data "aws_region" "current" {}

locals {
  lbcontroller = {
    enabled     = lookup(var.lbcontroller, "enabled", "false")
    saname      = lookup(var.lbcontroller, "sa_name", "aws-load-balancer-controller")
    namespace   = lookup(var.lbcontroller, "namespace", "kube-system")
  }
}