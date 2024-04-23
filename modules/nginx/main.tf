
resource "helm_release" "nginx" {

  count      = local.nginx.enabled ? 1 : 0

  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.10.0"
  namespace  = "ingress-nginx"
  create_namespace = true

#  values = "${path.module}./charts/nginx-values.yml"
  values = [
    "${file("${path.module}./charts/nginx-values.yml")}"
  ]  

  # set {
  #   name  = "clusterName"
  #   value = var.cluster_name
  # }

  # Configuracoes Personalizadas
  dynamic "set" {
    for_each = var.nginx_configs == "" ? {} : var.nginx_configs
    content {
      name = set.value.name
      value = set.value.value
    }
    
  }

}