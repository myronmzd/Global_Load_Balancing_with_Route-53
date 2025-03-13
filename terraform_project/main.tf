terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use the latest version compatible with 5.x
    }
  }
}

# Default provider configuration (required)
provider "aws" {
  region = "us-east-1" # Default provider for us-east-1
}

provider "aws" {
  alias  = "us-west-1" # Aliased provider for us-west-1
  region = "us-west-1"
}

module "network_us_east_1" {
  source = "./modules/network"
  # Default provider for us-east-1
  providers = {
    aws = aws  # Explicitly assigning the default provider
  }

  vpc_cidr                   = "10.0.0.0/16"
  public_subnet_cidrs_1      = "10.0.1.0/24"
  public_subnet_cidrs_2      = "10.0.2.0/24"
  private_subnet_cidrs       = "10.0.3.0/24"
  availability_zone_private  = "us-east-1b"   # As the private and public_1 is connected to one intances to give a public and prvate eni the same az
  availability_zone_public_1 = "us-east-1b"
  availability_zone_public_2 = "us-east-1a"
}

module "network_us_west_1" {
  source = "./modules/network"
  providers = {
    aws = aws.us-west-1 # Aliased provider for us-west-1
  }
  vpc_cidr                   = "10.1.0.0/16"
  public_subnet_cidrs_1      = "10.1.1.0/24"
  public_subnet_cidrs_2      = "10.1.2.0/24"
  private_subnet_cidrs       = "10.1.3.0/24"
  availability_zone_private  = "us-west-1c" # As the private and public_1 is connected to one intances to give a public and prvate eni the same az
  availability_zone_public_1 = "us-west-1c"
  availability_zone_public_2 = "us-west-1b"
}

module "compute_east_1" {
  source = "./modules/compute"
  # Default provider for us-east-1
  providers = {
    aws = aws  # Explicitly assigning the default provider
  }

  ami               = "ami-08b5b3a93ed654d19"
  instance_type     = "t2.micro"
  key_name          = "MykeyE"
  region               = "us-east-1" ## only passing it to so that it shows in ec2 instance 
  vpc_id            = module.network_us_east_1.vpc_id
  public_subnet_id  = module.network_us_east_1.public_subnet_ids
  private_subnet_id = module.network_us_east_1.private_subnet_id
  security_group_id = module.network_us_east_1.security_groups_id
  instance_profile  = module.iam.aws_iam_instance_profile
}

module "compute_west_1" {
  source = "./modules/compute"
  providers = {
    aws = aws.us-west-1 # Aliased provider for us-west-1
  }
  ami               = "ami-01eb4eefd88522422"
  instance_type     = "t2.micro"
  key_name          = "MykeyW"
  region            = "us-west-1" # only passing it to so that it shows in ec2 instance 
  vpc_id            = module.network_us_west_1.vpc_id
  public_subnet_id  = module.network_us_west_1.public_subnet_ids
  private_subnet_id = module.network_us_west_1.private_subnet_id
  security_group_id = module.network_us_west_1.security_groups_id
  instance_profile  = module.iam.aws_iam_instance_profile
}

# module "alb_us_east_1" {
#   source = "./modules/alb"
#   # Default provider for us-east-1
#   providers = {
#     aws = aws  # Explicitly assigning the default provider
#   }

#   security_group_id = module.network_us_east_1.security_groups_id
#   public_subnet_ids = module.network_us_east_1.public_subnet_idsss
#   vpc_id            = module.network_us_east_1.vpc_id
#   alb_name          = "albe"
#   target_group_name = "tgeast"
# }

# module "alb_us_west_1" {
#   source = "./modules/alb"
#   providers = {
#     aws = aws.us-west-1 # Aliased provider for us-west-1
#   }
#   security_group_id = module.network_us_west_1.security_groups_id
#   public_subnet_ids = module.network_us_west_1.public_subnet_idsss
#   vpc_id            = module.network_us_west_1.vpc_id
#   alb_name          = "albw"
#   target_group_name = "tgwest"
# }
# # can not give varaialbe name as public_subnet and private_subnet as it is already defined in the module


module "dns" {
  source = "./modules/dns"
  # Default provider for us-east-1
  providers = {
    aws = aws  # Explicitly assigning the default provider
  }

  domain_name            = "myronmzd.com"
  intance_public_ip1   = module.compute_east_1.public_ip
  intance_public_ip2   = module.compute_west_1.public_ip
  # alb_dns_name_us_east_1 = module.alb_us_east_1.alb_dns_name
  # alb_zone_id_us_east_1  = module.alb_us_east_1.alb_zone_id
  # alb_dns_name_us_west_1 = module.alb_us_west_1.alb_dns_name
  # alb_zone_id_us_west_1  = module.alb_us_west_1.alb_zone_id
}

module "iam" {
  source = "./modules/iam"
  # Default provider for us-east-1
  providers = {
    aws = aws  # Explicitly assigning the default provider
  }
  bucket_names = [module.s3_east1.bucket_name, module.s3_west1.bucket_name]
  bucket_arns  = [module.s3_east1.bucket_arn, module.s3_west1.bucket_arn]
}


module "s3_east1" {
  # Default provider for us-east-1
  providers = {
    aws = aws  # Explicitly assigning the default provider
  }
  source               = "./modules/s3"
  vpc_id               = module.network_us_east_1.vpc_id
  region               = "us-east-1" # only passing it to so that vpc endpoint can be created
  private_route_tables = module.network_us_east_1.private_route_table
}

module "s3_west1" {
  providers = {
    aws = aws.us-west-1 # Aliased provider for us-west-1
  }
  source               = "./modules/s3"
  vpc_id               = module.network_us_west_1.vpc_id
  region               = "us-west-1"
  private_route_tables = module.network_us_west_1.private_route_table
}

