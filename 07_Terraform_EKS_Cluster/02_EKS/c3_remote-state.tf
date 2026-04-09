#DataSource
#Remote State Data Source
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-us-east-1-zoa8dy"
    key = "vpc/dev/terraform.tfstate"
    region = var.aws_region
  }
}

#Outputs