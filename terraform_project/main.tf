provider "aws" {
  region = "us-east-1"
  alias  = "usEast"
}

provider "aws" {
  region = "us-west-1"
  alias  = "usWest"
}

module "network_us_east_1" {
  source = "./modules/network"
  providers = {
    aws = aws.usEast
  }
  vpc_cidr                  = "10.0.0.0/16"
  public_subnet_cidrs       = "10.0.1.0/24"
  private_subnet_cidrs      = "10.0.2.0/24"
  availability_zone_pravate = "us-east-1a"
  availability_zone_public  = "us-east-1b"
}

module "network_us_west_1" {
  source = "./modules/network"
  providers = {
    aws = aws.usWest
  }
  vpc_cidr                  = "10.1.0.0/16"
  public_subnet_cidrs       = "10.1.1.0/24"
  private_subnet_cidrs      = "10.1.2.0/24"
  availability_zone_pravate = "us-west-1a"
  availability_zone_public  = "us-west-1b"
}

module "compute_east_1" {
  source = "./modules/compute"
  providers = {
    aws = aws.usEast
  }
  ami               = "ami-0c55b159cbfafe1f0"
  instance_type     = "t2.micro"
  vpc_id            = module.network_us_east_1.vpc_id
  public_subnet_id  = module.network_us_east_1.public_subnet_id
  private_subnet_id = module.network_us_east_1.private_subnet_id
  security_group_id = module.network_us_east_1.security_groups_id
}

module "compute_west_1" {
  source = "./modules/compute"
  providers = {
    aws = aws.usWest
  }
  ami               = "ami-0c55b159cbfafe1f0"
  instance_type     = "t2.micro"
  vpc_id            = module.network_us_west_1.vpc_id
  public_subnet_id  = module.network_us_west_1.public_subnet_id
  private_subnet_id = module.network_us_west_1.private_subnet_id
  security_group_id = module.network_us_west_1.security_groups_id
}

module "alb_us_east_1" {
  source = "./modules/alb"
  providers = {
    aws = aws.usEast
  }
  security_group_id = module.network_us_east_1.security_groups_id
  public_subnet_ids = module.network_us_east_1.public_subnet_id
  vpc_id            = module.network_us_east_1.vpc_id
  alb_name          = "albe"
  target_group_name = "tgeast"
}

module "alb_us_west_1" {
  source = "./modules/alb"
  providers = {
    aws = aws.usWest
  }
  security_group_id = module.network_us_west_1.security_groups_id
  public_subnet_ids = module.network_us_west_1.public_subnet_id
  vpc_id            = module.network_us_west_1.vpc_id
  alb_name          = "albw"
  target_group_name = "tgwest"
}
# can not give varaialbe name as public_subnet and private_subnet as it is already defined in the module


module "dns" {
  source = "./modules/dns"

  domain_name            = "myronmzd.com"
  alb_dns_name_us_east_1 = module.alb_us_east_1.alb_dns_name
  alb_zone_id_us_east_1  = module.alb_us_east_1.alb_zone_id
  alb_dns_name_us_west_1 = module.alb_us_west_1.alb_dns_name
  alb_zone_id_us_west_1  = module.alb_us_west_1.alb_zone_id
}

module "s3_east1" {
  source = "./modules/s3"
  providers = {
    aws = aws.usEast
  }
  bucket_name         = "3325u0jfw0324nm0"
  vpc_id              = module.network_us_east_1.vpc_id
  region              = "us-east-1"
  private_route_table = module.network_us_west_1.private_route_table
}

module "s3_west1" {
  source = "./modules/s3"
  providers = {
    aws = aws.usWest
  }
  bucket_name         = "23423034254320321543908"
  vpc_id              = module.network_us_west_1.vpc_id
  region              = "us-west-2"
  private_route_table = module.network_us_west_1.private_route_table
}