# Local values used throughout the EKS configuration
# Helps reinforce naming consistency and reduce dupplication
locals {
  owners = var.business_division # Example: Retail

  environment = var.environment_name # Examole: dev

  name = "${local.owners}-${var.environment_name}"  # Examole: retail-dev

  eks_cluster_name = "${local.name}-${var.cluster_name}"  # Examole: "retail-dev-eksdemo"
}