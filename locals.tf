locals {
#  cluster_name = "education-eks-${random_string.suffix.result}"
  cluster_name = {
    manager = lookup(var.cluster_name, "manager", "manager")
    member01 = lookup(var.cluster_name, "member01", "worker01")
    member02 = lookup(var.cluster_name, "member02", "worker02")
  }
  enabled = {
    manager = lookup(var.cluster_name, "enabled_manager", "false")
    member01 = lookup(var.cluster_name, "enabled_member01", "false")
    member02 = lookup(var.cluster_name, "enabled_member02", "false")
  }

}
