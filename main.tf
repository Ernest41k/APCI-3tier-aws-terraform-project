module "vpc" {
  source = "./vpc"
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  tags = local.project_tags
  vpc_cidr_block = var.vpc_cidr_block
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zone = var.availability_zone
}

module "auto-scaling" { 
  source = "./auto-scaling"
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  image_id = var.image_id
  instance_type = var.instance_type
  tags = local.project_tags
  key_name = var.key_name
  public_subnet_1 = module.vpc.public_subnet_1
  public_subnet_2 = module.vpc.public_subnet_2
  availability_zone = var.availability_zone
  alb_sg = module.alb.alb_sg
  alb_target_group_arns = module.alb.alb_target_group_arns
  private_subnet_1 = module.vpc.private_subnet_1
  private_subnet_2 = module.vpc.private_subnet_2
  alb_private_target_group_arns = module.alb.alb_private_target_group_arns
  alb_private_sg = module.alb.alb_sg
}

module "alb" {
  source = "./alb"
  public_subnet_1 = module.vpc.public_subnet_1
  public_subnet_2 = module.vpc.public_subnet_2
  tags = local.project_tags
  vpc_id = module.vpc.vpc_id
  public_sg = module.auto-scaling.public_sg
  ssl_policy = var.ssl_policy
  certificate_arn = var.certificate_arn
  private_subnet_1 = module.vpc.private_subnet_1
  private_subnet_2 = module.vpc.private_subnet_2
}

module "route53" {
  source = "./route53"
  dns_name = var.dns_name
  zone_id = var.zone_id
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id = module.alb.alb_zone_id
}

module "rds" {
  source = "./rds"
  tags = local.project_tags
  vpc_cidr_block = var.vpc_cidr_block
  username = var.username
  password = var.password
  engine_version = var.engine_version
  vpc_id = module.vpc.vpc_id
  instance_class = var.instance_class
  private_subnet_3 = module.vpc.private_subnet_3
  private_subnet_4 = module.vpc.private_subnet_4
}
