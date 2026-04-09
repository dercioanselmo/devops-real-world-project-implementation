# Public Subnet Tags for EKS Load Balancer Support
resource "aws_ec2_tag" "eks_subnet_tag_public_elb" {
  for_each = toset(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  resource_id = each.value
  key = "kubernetes.io/role/elb"
  value = "1"
}

resource "aws_ec2_tag" "eks_subnet_tag_public_cluster" {
  for_each = toset(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  resource_id = each.value
  key = "kubernetes.io/cluster${local.eks_cluster_name}"
  value = "shared" # Associate subnet to the cluster. Multiple EKS Cluster can use same subnet, if needed
}


# Public Subnet Tags for EKS Load Balancer Support
resource "aws_ec2_tag" "eks_subnet_tag_private_elb" {
  for_each = toset(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  resource_id = each.value
  key = "kubernetes.io/role/internal-elb"
  value = 1
}

resource "aws_ec2_tag" "eks_subnet_tag_private_cluster" {
  for_each = toset(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  resource_id = each.value
  key = "kubernetes.io/cluster${local.eks_cluster_name}"
  value = "shared"
}


# These subnet tags are the glue that connects AWS Networking with Kubernetes services
# AWS knows the Subnet to use, based in it.