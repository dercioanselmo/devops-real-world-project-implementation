# datasources-and-locals.tf

data "aws_availability_zones" "available" {
  state = "available"
}
# datasources-and-locals.tf - Stable version for me-central-1

locals {
  # Explicitly define only stable AZs for me-central-1
  # Avoid mec1-az2 (me-central-1b) as it is currently unstable
  azs = ["eu-central-1a", "eu-central-1b"]
  #TODO: Restore to the initial generic algorithm

  public_subnets = [
    for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)
  ]

  private_subnets = [
    for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 10)
  ]
}