resource "kubernetes_secret" "grafana" {
  count      = var.grafana.enabled ? 1 : 0
  metadata {
    name      = "grafana"
  }

  data = {
    admin-user     = "admin"
    admin-password = random_password.grafana[count.index].result
  }

  depends_on = [ 
    resource.helm_release.prometheus,
    resource.random_password.grafana
   ]  
}

resource "random_password" "grafana" {
  count      = var.grafana.enabled ? 1 : 0
  length = 24

  depends_on = [ 
    resource.helm_release.prometheus
   ]
}

resource "helm_release" "grafana" {
  count      = var.grafana.enabled ? 1 : 0
  chart      = "grafana"
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "grafana"
  version    = "7.3.7"
  create_namespace = true

  values = [
    templatefile("${path.module}/templates/grafana-values.yaml", {
      admin_existing_secret = kubernetes_secret.grafana[count.index].metadata[0].name
      admin_user_key        = "admin-user"
      admin_password_key    = "admin-password"
      prometheus_svc        = "${helm_release.prometheus[count.index].name}-server"
      replicas              = 1
    })
  ]
  depends_on = [ 
    resource.helm_release.prometheus
   ]
}