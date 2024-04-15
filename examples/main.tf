module "aws-network" {
  source      = "./modules/aws-network"
  vpc_cidr    = "10.0.0.0/16"
  region      = "us-east-1"
  environment = "dev"
}