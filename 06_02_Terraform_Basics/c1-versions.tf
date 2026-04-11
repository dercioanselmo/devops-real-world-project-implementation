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
}
provider "aws" {
  region = "me-central-1"
}