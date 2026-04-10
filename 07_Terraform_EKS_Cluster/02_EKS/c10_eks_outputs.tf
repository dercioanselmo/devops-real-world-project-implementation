# Output of EKS Cluster API server endpoint
# Used by kubectl and external tools to communicate with the cluster
output "eks_cluster_endpoint" {
    value = aws_eks_cluster.main.endpoint
    description = "EKS API Server endpoint"
}

output "eks_cluster_id" {
  value = aws_eks_cluster.main.id
  description = "The name/id of the EKS cluster"
}

# Kubernetes version used in the EKS cluster
output "eks_cluster_version" {
  value = aws_eks_cluster.main.version
  description = "EKS Kubernetes versionr"
}

# EKS Cluster name. Helpfull when scripting, `aws eks update-kubeconfig`, etc
output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
  description = "EKS Cluster name"
}

# EKS Cluster certificate authority data. 
# Necessary when setting up kubeconfig or accessing EKS via API
output "eks_cluster_certificate_authority_data" {
  value = aws_eks_cluster.main.certificate_authority[0].data
  description = "Base64 encoded CA certificate for kubectl config"
}

#Pribate Node Group name, useful for autoscaler configs, dashboards, tagging, etc
output "private_node_group_name" {
  value = aws_eks_cluster.main.id
  description = "Name of the EKS private node group"
}

# IAM Role ARN used by the EKS Node Group
# Useful for IRSA setup or attaching additional permission
output "eks_node_instance_role_arn" {
  value = aws_iam_role.eks_nodegroup_role.arn
  description = "IAM Role ARN used by EKS node group (EC2 worker nodes)"
}

# Output command to configure kubectl for EKS cluster
# Can be runned directly after apply, to configure kubectl client on local machine to access the cluster
output "to_configure_kubectl" {
  value = "aws eks --region ${var.aws_region} update-kubeconfig --name ${local.eks_cluster_name}"
  description = "Command to update local kubeconfig to connect to the EKS cluster"
}