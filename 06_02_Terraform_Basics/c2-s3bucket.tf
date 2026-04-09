resource "random_string" "suffix" {
  length           = 6
  special          = false
  upper            = false
}

#Resource block
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "devopsdemo-${random_string.suffix.result}"

  tags = {
    Name         = "DevOps Demo Bucket"
    Environment  = "Dev"
    Owner        = "Dercio Anselmo"
    Organization = "DA Tech"
  }
}