module "vpc" {
    source = "./modules/vpc"
    vpc_cidr_block = var.vpc_cidr_block
    public_subnets_cidr = var.public_subnets_cidr
    private_subnets_cidr = var.private_subnets_cidr
    vpc_name = var.vpc_name 
}

module "bastion" {
    source = "./modules/bastion"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.public_subnets[0]
    ami_id = var.ami_id
    instance_type = var.instance_type
    public_key = var.public_key
    ingress_ports = var.ingress_ports 
}