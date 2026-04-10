#Terraform Block
terraform {
  required_version = ">=1.0.0" #Terreform CLI version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0" #Provider version
    }
  }

  # Remote Backend configuration using S3
  backend "s3" {
    bucket = "tfstate-dev-us-east-1-zoa8dy"
    key = "eks/dev/terraform.tfstate"
    region = "us-east-1" # Variables still not allowed in the terraform block
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}