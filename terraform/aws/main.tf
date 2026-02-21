module "security_group" {
  source = "./modules/security_group"
}

module "ec2" {
  source            = "./modules/ec2"
  depends_on        = [module.security_group]
  security_group_id = module.security_group.security_group_id
}
