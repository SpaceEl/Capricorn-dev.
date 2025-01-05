# store the terraform state file in s3
terraform {
  backend "s3" {
    region    = "us-east-1"
    bucket    = "testterrabucketform"
    key       = "prod/terraform.tfstate"
    profile   = "default"
  }
}