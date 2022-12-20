#Network

module "my_network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  instance_tenancy   = var.instance_tenancy
  tags               = var.tags
  sn_cidr_block      = var.sn_cidr_block
  availability_zones = var.az
  ec2_ids            = module.my_compute.ec2_ids
}

#Compute
module "my_compute" {
  source        = "./modules/compute"
  ingress_rules = var.ingress_rules
  instance_type = var.instance_type
  ami           = var.ami
  tags          = var.tags
  vpc_id        = module.my_network.vpc_id
  sn_ids        = module.my_network.sn_ids
  sg_id         = module.my_network.sg_id

}



