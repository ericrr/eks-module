locals {
  nginx = {
    enabled     = lookup(var.nginx, "enabled", "false")
#    saname      = lookup(var.nginx, "sa_name", "aws-load-balancer-controller")
    namespace   = lookup(var.nginx, "namespace", "ingress-nginx")
  }

  # helm_chart_values = templatefile(
  #   "${path.module}/charts/nginx-values.yml", {
  #     namespace     = local.nginx.namespace
  #   }
  # )

}