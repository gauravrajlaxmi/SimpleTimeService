provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../modules/network"
}

module "alb" {
  source = "../modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "ecs" {
  source = "../modules/ecs"

  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  cluster_name     = "simple-ecs-cluster"
  alb_target_group = module.alb.target_group_arn
  alb_listener     = module.alb.listener_arn
}

output "alb_dns" {
  value = module.alb.alb_dns_name
}
