# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


# data "aws_eks_cluster" "cluster" {
#   name     = var.cluster_name.manager
# }

# data "aws_eks_cluster" "cluster" {
#   for_each = toset(data.aws_eks_clusters.clusters.names)
#   name     = each.value
# }

# data aws_eks_cluster_auth "cluster" {
#   name = var.cluster_name.manager
# }