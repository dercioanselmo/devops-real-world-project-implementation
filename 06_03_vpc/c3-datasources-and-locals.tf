#Data Block
data "aws_availability_zones" "available" {
  state = "available"
}

#Locals Block
locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  # Making sure the provate and public subnet IPs do not overlaps. using cidrsubnet to calculate the IPs 
  # Public Subnets:   10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24
  public_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)]
  # Private Subnets:  10.0.10.0/24, 10.0.11.0/24, 10.0.12.0/24   (shifted by 10)
  private_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k+1)]

  #apple@apples-MacBook-Pro 06_Terraform_Basics % terraform console
  #> cidrsubnet("10.0.0.0/16", 8, 0)
  #"10.0.0.0/24"
  #> cidrsubnet("10.0.0.0/16", 8, 1)
  #"10.0.1.0/24"
  #> cidrsubnet("10.0.0.0/16", 8, 2)
  #> cidrsubnet("10.0.0.0/16", 8, 0+10)
  #"10.0.10.0/24"
  #> cidrsubnet("10.0.0.0/16", 8, 1+10)
  #"10.0.11.0/24"
  #> cidrsubnet("10.0.0.0/16", 8, 2+10)
  #"10.0.12.0/24"
  #>  
}