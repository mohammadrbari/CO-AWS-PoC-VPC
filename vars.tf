variable "region" {
  default = "eu-west-2"
}

variable "vpc-cidr" {
  default = "10.252.0.0/20"
}

variable "additional-cidr-vpc" {
  default = "100.64.0.0/24"
}

variable "azs" {
  type = list
  default = ["eu-west-2a" , "eu-west-2b"]
}

variable "poc-private-subnets" {
  type = list
  default = ["10.252.3.0/24" , "10.252.4.0/24", "10.252.5.0/24", "10.252.6.0/24", "10.252.7.0/24" , "10.252.8.0/24", "10.252.9.0/24", "10.252.10.0/24"]
}

variable "poc-public-subnets" {
  type = list
  default = ["10.252.1.0/24" , "10.252.2.0/24"]
}

variable "poc-mgmt-subnets" {
  type = list
  default = ["100.64.0.0/27", "100.64.0.96/27"]
}
variable "private-ip" {
  type = list
  default = ["10.252.1.100/24"]
}
#Default Route
variable "default-route" {
  type = list
  default = ["0.0.0.0/0" ]
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "key_pairs" {
  type = string
  default = "2021-04-26-tf-mbari"
}