terraform {
    required_version = ">= 0.12"
}

module "gravatar-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"
  cidr = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = merge(var.tags, {"Name"="gravatar-hz"})
}
module "gravatar-ecs" {
  source         = "./modules/ecs-cluster"
  VPC_ID         = module.gravatar-vpc.vpc_id
  CLUSTER_NAME   = "gravatar-ecs"
  INSTANCE_TYPE  = "t2.medium"
  SSH_KEY_NAME   = "gravatar-hz-kp"
  VPC_SUBNETS    = module.gravatar-vpc.private_subnets
  LOG_GROUP      = "gravatar-log-group"
  AWS_ACCOUNT_ID = var.AWS_ACCOUNT_ID
  AWS_REGION     = var.AWS_REGION
}

module "gravatar-service" {
  source              = "./modules/ecs-service"
  VPC_ID              = module.gravatar-vpc.vpc_id
  APPLICATION_NAME    = "gravatar-service"
  APPLICATION_PORT    = "5000"
  APPLICATION_VERSION = "latest"
  CLUSTER_ARN         = module.gravatar-ecs.cluster_arn
  SERVICE_ROLE_ARN    = module.gravatar-ecs.service_role_arn
  AWS_REGION          = var.AWS_REGION
  HEALTHCHECK_MATCHER = "200"
  CPU_RESERVATION     = "256"
  MEMORY_RESERVATION  = "256"
  LOG_GROUP           = "gravatar-log-group"
  DESIRED_COUNT       = 2
  ALB_ARN             = module.gravatar-alb.alb_arn
}

module "gravatar-alb" {
  source             = "./modules/alb"
  VPC_ID             = module.gravatar-vpc.vpc_id
  ALB_NAME           = "gravatar-alb"
  VPC_SUBNETS        = module.gravatar-vpc.public_subnets
  DEFAULT_TARGET_ARN = module.gravatar-service.target_group_arn
  INTERNAL           = false
  ECS_SG             = module.gravatar-ecs.cluster_sg
  TAGS               = var.tags
}

module "gravatar-s3" {
  source               = "./modules/s3"
  BUCKET_NAME          = "gravatar-terraform-${var.AWS_ACCOUNT_ID}-${var.AWS_REGION}"
  BUCKET_KEY           = "terraform_state"
  TAGS                 = var.tags
}
