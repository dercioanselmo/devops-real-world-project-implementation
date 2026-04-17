# Giving AWS Control Plane access our AWS accunt resources
# IAM Role 
# This role is assumed by EKS service to manage the control plane resouces
resource "aws_iam_role" "eks_cluster" {
  #Unique name dr the control plane IAM Role
  name = "${local.name}-eks-cluster-role"

  #Trust policy to allow EKS to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"  # Only this service can assume this role
        }
    }]
  })

  tags = var.tags
}

# Attach the required policy for EKS to manage cluster control plane
# This is mandatory for all EKS Clusters
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach VPC Resource Controller policy
# Required for advanced networking, Fargate, and Karpenter support
# Recomended to include by default for production ready EKS
resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}