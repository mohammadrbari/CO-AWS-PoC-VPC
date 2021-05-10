terraform {
  backend "s3" {
    bucket = "co-aws-tfstate"
    key    = "aws-co-poc/terraform.tfstate"
    region = "eu-west-2"
    profile = "co-aws-poc"
  }
}