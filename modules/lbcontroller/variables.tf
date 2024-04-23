variable "lbcontroller" {
  type = map(string)
  description = "Input values lb controller"
}


variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account."
}

# variable "service_account_name" {
#   type        = string
#   default     = "aws-load-balancer-controller"
#   description = "ALB Controller service account name"
# }

# variable "helm_chart_name" {
#   type        = string
#   default     = "aws-load-balancer-controller"
#   description = "ALB Controller Helm chart name to be installed"
# }

# variable "helm_chart_release_name" {
#   type        = string
#   default     = "aws-load-balancer-controller"
#   description = "Helm release name"
# }


# variable "mod_dependency" {
#   default     = null
#   description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
# }

# variable "settings" {
#   default     = {}
#   description = "Additional settings which will be passed to the Helm chart values."
# }