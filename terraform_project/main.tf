provider "aws" {
  region = "us-east-1"
}

module "network_us_east_1" {
  source = "./modules/network"

  cidr_block          = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "network_us_west_2" {
  source = "./modules/network"
  providers = {
    aws = aws.us-west-2
  }

  cidr_block          = "10.1.0.0/16"
  public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
}

module "compute" {
  source = "./modules/compute"

  ami                 = "ami-0c55b159cbfafe1f0"
  instance_type       = "t2.micro"
  subnet_id_us_east_1 = module.network_us_east_1.public_subnet_ids[0]
  subnet_id_us_west_2 = module.network_us_west_2.public_subnet_ids[0]
  alb_sg_id           = module.network_us_east_1.alb_sg_id
  subnet_ids_us_east_1 = module.network_us_east_1.public_subnet_ids
  subnet_ids_us_west_2 = module.network_us_west_2.public_subnet_ids
  vpc_id_us_east_1    = module.network_us_east_1.vpc_id
  vpc_id_us_west_2    = module.network_us_west_2.vpc_id
}

module "dns" {
  source = "./modules/dns"

  domain_name          = "example.com"
  alb_dns_name_us_east_1 = module.compute.alb_dns_name_us_east_1
  alb_zone_id_us_east_1  = module.compute.alb_dns_name_us_east_1
  alb_dns_name_us_west_2 = module.compute.alb_dns_name_us_west_2
  alb_zone_id_us_west_2  = module.compute.alb_dns_name_us_west_2
}

module "s3" {
  source = "./modules/s3"

  bucket_name     = "my-bucket"
  vpc_id          = module.network_us_east_1.vpc_id
  region          = "us-east-1"
  route_table_ids = module.network_us_east_1.public_subnet_ids
}
