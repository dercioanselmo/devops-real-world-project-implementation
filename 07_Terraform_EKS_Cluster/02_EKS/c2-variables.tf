variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "me-central-1"
}

variable "environment_name" {
  description = "Environment name used in resource names and tags"
  type        = string
  default     = "dev"
}

variable "business_division" {
  description = "Business division in the organization this infrasructure belongs to"
  type        = string
  default     = "retail"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster, also used as prefix in names of related resources"
  type        = string
  default     = "eksdemo"
}

variable "cluster_version" {
  description = "Kubernetes minor version to use for the EKS Cluster. (e.g. 1.28, 1.29)"
  type        = string
  default     = null # Null  makes AWS assume the last Kubernetes available today. However this will be overwritten by the version assigned at terraform.tfvars file
}

variable "cluster_service_ipv4_cidr" {
  description = "Service CIDR range for Kubernetes services. Optional - leave null to use AWS default"
  type        = string
  default     = null
}

variable "cluster_endpoint_private_access" {
  description = "Enable/Disabele private to EKS control plane endpoint"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Enable/Disabele public to EKS control plane endpoint"
  type        = bool
  default     = true
  # true is allowing EKS cluster to be accessed publicly, While testing. In production must be false.
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks allowed to access public EKS endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply to EKS and related resources"
  type        = map(string)
  default     = {
    Terraform = "true"
  }
}


# Nodes related variables
variable "node_instance_types" {
  description = "List of EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}


variable "node_capacity_type" {
  description = "Instance capacity type: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_nock_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}