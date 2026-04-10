# IAM Role for EKS Managed Node Group (EC2 Worker Nodes)
# This role will be assumed by EC2 instances launched in the node group

resource "aws_iam_role" "eks_nodegroup_role" {
  # IAM role name following environment and division-based naming
  name = "${local.name}-eks-nodegroup-role"

  # Trust policy: Allow EC2 service to assume this role
    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          service = "ec2.amazonaws.com" 
        }
    }]
  })

  tags = var.tags
}

# IAM Policy attachment: AmazonEKSWorkerNodePolicy
# Grants basic node group access to EKS Cluster
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# IAM Policy attachment: AmazonEKS_CNI_Policiy
# Allows node to manage networking (ENIs) via VPC plugin. Without this, pods cannot have the IP in the cluster.
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policiy"
}


# IAM Policy Attachment: AmazonEC2ContainerRegistryReadOnly
# Grants nodes permission to pull images from Amazon ECR
resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
  role       = aws_iam_role.eks_nodegroup_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
