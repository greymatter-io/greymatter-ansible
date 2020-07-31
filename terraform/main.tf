locals {
  account = "492523869507"
}

provider "aws" {
  region  = "us-east-1" # Nova region
  # region  = "us-west-2" # Oregan region
  version = "~> 2.7"
}

terraform {
  backend "s3" {
    bucket   = "terraform-greymatter-backend" # Nova region
    # bucket   = "terraform-greymatter-backend-us-west-2" # Oregan region
    key      = "tfstate"
  }
}

module "networking" {
  source     = "./modules/networking"
}

module "dns" {
  source = "./modules/dns"

  vpc_id      = module.networking.gm_vpc_id
}

module "compute" {
  source = "./modules/compute"

  # pub_sub_1_id        = module.networking.gm_public_subnet_1
  gm_public_subnets   = module.networking.gm_public_subnets
  gm_sg_id            = module.networking.gm_sg_id
  private_zone_id     = module.dns.gm_private_zone_id
  private_zone_name   = module.dns.gm_private_zone_name
}