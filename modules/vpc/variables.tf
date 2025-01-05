variable "region" {
  description = "this is the AWS region where the services will be deployed"
}

variable "project_name" {
  description = "this is the name of the project"
}

variable "vpc_cidr" {
  description = "this is the cidr block for the vpc"
}

variable "public_subnet_cidr_az1" {
  description = "this is the cidr block for the public subnet in az1"
}

variable "private_data_subnet_cidr_az2" {
  description = "this is the cidr block for the private data subnet in az2"
}