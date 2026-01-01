locals {
  common_tags = merge(
    {
      Project     = var.name_prefix
      Environment = var.env
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix        = var.name_prefix
  env                = var.env
  vpc_cidr           = var.vpc_cidr
  az_count           = var.az_count
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  tags               = local.common_tags
}

module "vpc_endpoints" {
  source = "../../modules/vpc_endpoints"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  # endpoint SG will allow HTTPS from within VPC
  vpc_cidr           = var.vpc_cidr

  tags = local.common_tags
}
