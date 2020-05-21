locals {
  account = "492523869507"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.7"
  profile = "gm"
}

terraform {
  backend "s3" {
    bucket   = "terraform-greymatter-backend"
    key      = "tfstate"
    region   = "us-east-1"
    profile  = "gm"
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

  pub_sub_1_id        = module.networking.gm_public_subnet_1
  gm_sg_id            = module.networking.gm_sg_id
  private_zone_id     = module.dns.gm_private_zone_id
  private_zone_name   = module.dns.gm_private_zone_name
}