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

  #Define the service CIDR range used by Kubernetes service (Optional)
  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }
  
  #Enable EKS control plane logging for visibility and debugging
  enabled_cluster_log_types = [ 
    "api",          # API Server audit logs
    "audit",        # Kubernetes audit logs
    "authenticator", # Authenticator logs for IAM auth
    "controllerManager",
    "scheduler"     # Logs for pod scheduling

  ]

  # Ensure IAM policy attachments complete before cluster creation
  depends_on = [ 
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
   ]

   tags = var.tags

   # Access config - How do we control who can access our EKS cluster
   #
   # authenticate_mode = "API_AND_CONFIG_MAP"
   # --> Thie means we are using both methods
   # 1. The old way (aws-auth ConfigMap) - still works
   # 2. The new way (Access Entries API) - future-proof for AWS directions
   #
   # bootstrap+cluster_creator_admin_permissions = true
   # --> This makes sure the person who creates the cluster (Running the Terraform) automatically gets admin (cluster-admin) access.
   #
   # Simply:
   # - Keep the old system so everthing works today
   # - Enable the new system so the cluster is future-ready
   # - And guaranteed access to the creator allways have admin access
   access_config {
     authentication_mode = "API_AND_CONFIG_MAP"
     bootstrap_cluster_creator_admin_permissions = true
   }

}