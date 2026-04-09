# Cleate the EKS Cluster
# This is the control plane

resource "aws_eks_cluster" "main" {
  name = local.eks_cluster_name
  # Kubernetes Version to be used for the control plane
  version = var.cluster_version

  # IAM role used by EKS to manage the control plane
  role_arn = aws_iam_role.eks_cluster.arn

  # VPC Configuration for control plane networking
  vpc_config {
    # Subnets where EKS control plne ENIs will be placed (Must be private)
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

    # Allow access to private endpoint (Inside VOC)
    endpoint_private_access = var.cluster_endpoint_private_access
    
    # Allow access to public endpoint ()From internet, controlled via CIDRs
    endpoint_public_access = var.cluster_endpoint_public_access

    #List of CIDRs allowed to reach the public endpoint
    public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  }


  
}