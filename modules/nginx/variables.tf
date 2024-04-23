variable "nginx" {
  type = map(string)
  description = "Input values nginx ingress controller"
}

variable "nginx_configs" {
  type = map(string)
  description = "Dynamic values nginx ingress controller"
  default = {}
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}