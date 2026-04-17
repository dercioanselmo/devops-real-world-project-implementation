#Terraform Block
terraform {
  required_version = ">=1.0.0" #Terreform CLI version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0" #Provider version
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  # Remote Backend
  backend "s3" {
    bucket = "tfstate-dev-eu-central-1-a65beq"
    key = "vpc/dev/terraform.tfstate"
    region = "eu-central-1" # Variables still not allowed in the terraform block
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}