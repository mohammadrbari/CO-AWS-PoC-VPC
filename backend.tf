terraform {
  backend "s3" {
    bucket = "co-aws-tfstate"
    key    = "aws-co-poc/terraform.tfstate"
    region = "eu-west-2"
    # pls change your own personal profile for aws access and secret key
    profile = "co-aws-poc"
  }
}