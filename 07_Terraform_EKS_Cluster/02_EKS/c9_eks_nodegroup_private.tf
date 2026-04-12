# EKS Managed Node Group - In the privste subnet
resource "aws_eks_node_group" "private_nodes" {
  
  # EKS Cluster Name
  cluster_name = aws_eks_cluster.main.name
  
  # Logical name for this group in EKS Cluster
  node_group_name = "${local.name}-private-ng"

  # IAM Role to be assumed by the worker nodes EC2 instances 
  node_role_arn = aws_iam_role.eks_nodegroup_role.arn

  # Subnet where worker nodes will be launched (Private subnet)
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  # EC2 Instance types of worker nodes (t3.medium, m5.large, etc)
  instance_types = var.node_instance_types

  # ON_DEMAND or SPOT
  capacity_type = var.node_capacity_type

  # Use Amazon Linus AMI - Latest Amazon-Managed OS optimized for EKS
  # Fully supported in Kubernetes v1.25+ 
  # Better security updated packages and long-term support
  ami_type = "AL2023_x86_64_STANDARD"

  # Role volume size for each node 
  disk_size = var.node_nock_size

  # configure auto-scaling limits and defaults
  scaling_config {
    #Desired number of nodes when the node group is created
    desired_size = 2

    # Minimum number of nodes allowed
    min_size = 1

    # Maximum number of nodes that the group can scale to
    max_size = 6
  }

  # set the max percentage of nodes that can be unavailable during updates
  update_config {
    max_unavailable_percentage = 33
  }

  # Force node group update when EKS AMI version changes
  force_update_version = true

  # Apply labels to each EC2 instance for easier scheduling and management in Kubernetes
  # Optionnal, will allow latter, if necessary schedule pods by environment or team
  labels = {
    "env" = var.environment_name
    "team" = var.business_division
  }

  # Tags for the node group and associated EC2 instances
  tags = merge(var.tags, {
    # Standard EC2 name tag
    Name = "${local.name}-private-ng"

    # Local environment (dev, qa, prod)
    Environment =  var.environment_name
  })

  # Ensure IAM Role policies are attached before creating the node group
  depends_on = [ 
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy
   ]

}