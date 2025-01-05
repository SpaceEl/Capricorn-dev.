# declare aws provider
provider "aws" {
  region                       = var.region
  profile                      = "default"
}

# create vpc module
module "vpc" {
  source                       = "../../modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_cidr_az1       = var.public_subnet_cidr_az1
  private_data_subnet_cidr_az2 = var.private_data_subnet_cidr_az2
}

# create security groups module
module "security-groups" {
  source                       = "../../modules/security-groups"
  project_name                 = module.vpc.project_name
  vpc_id                       = module.vpc.vpc_id
}

# create ec2 module
module "instances" {
  source                       = "../../modules/instances"
  project_name                 = module.vpc.project_name
  private_data_subnet_az2_id   = module.vpc.private_data_subnet_az2_id
  private-instance-sg-id       = module.security-groups.private-instance-sg-id
  public_subnet_az1_id         = module.vpc.public_subnet_az1_id
  public-instance-sg-id        = module.security-groups.public-instance-sg-id
  instance_type                = var.instance_type
  env                          = var.env
}