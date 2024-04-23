module "manager_lbcontroller" {
  source          = "./modules/lbcontroller"
  count = var.lbcontroller.enabled ? 1 : 0

  cluster_name    =  local.cluster_name.manager
  lbcontroller    =  var.lbcontroller
  cluster_identity_oidc_issuer  = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn

  depends_on = [ 
    module.eks 
  ]

}

module "manager_nginx" {
  source          = "./modules/nginx"
  count           = var.nginx.enabled ? 1 : 0

  cluster_name    = local.cluster_name.manager
  nginx           = var.nginx
  nginx_configs   = var.nginx_configs

  depends_on = [ 
    module.eks 
  ]

}

