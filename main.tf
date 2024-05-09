module "blue_vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = "100.64.0.0/16"
  vpc_name          = "blue_vpc"
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
  subnet_cidrs      = ["100.64.0.0/24", "100.64.10.0/24", "100.64.20.0/24"]

}

# Define the Blue High Availability module
module "hai_blue" {
  source     = "./modules/asg"
  vpc_name   = "blue_vpc"
  sg_id      = module.security_group.security_group_id[0]
  vpc_id     = module.blue_vpc.vpc_id
  subnet_ids = module.blue_vpc.subnet_ids
}

# Define the Green VPC module
module "green_vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = "192.168.0.0/16"
  vpc_name          = "green_vpc"
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
  subnet_cidrs      = ["192.168.0.0/24", "192.168.10.0/24", "192.168.20.0/24"] // The CIDR blocks for the subnets
}

# Define the Green High Availability module
module "hai_green" {
  source     = "./modules/asg"
  vpc_name   = "green_vpc"
  sg_id      = module.security_group.security_group_id[1]
  vpc_id     = module.green_vpc.vpc_id
  subnet_ids = module.green_vpc.subnet_ids

}

#Define the SecurityGroups module
module "SecurityGroups" {
  source  = "./SecurityGroups"
  vpc_ids = [module.blue_vpc.vpc_id, module.green_vpc.vpc_id]
}
