module "aws-network" {
  source      = "./modules/aws-network"
  vpc_cidr    = var.vpc_cidr
  rtb_cidr    = var.rtb_cidr
  resources   = var.resources
  region      = var.region
  environment = var.environment
}
