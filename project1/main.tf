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
    subnet_id = module.vpc.public_subnets[var.public_subnets_cidr[0]]
    ami_id = var.ami_id
    instance_type = var.instance_type
    public_key = var.public_key
    ingress_ports = var.ingress_ports 
}


module "instance" {
    source = "./modules/instance"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.private_subnets[var.private_subnets_cidr[1]]
    instance_type = var.instance_type
    private_host_ami = var.private_host_ami
    security_groups = [module.bastion.bastion_sg_id]
    ssh_key_name = var.ssh_key_name
    ingress_ports = var.ingress_ports 
}


# resource "aws_instance" "private_host" {
#     ami = var.private_host_ami
#     instance_type = var.instance_type
#     vpc_security_group_ids = [aws_security_group.private_host_sg.id]
#     subnet_id = module.vpc.private_subnets[var.private_subnets_cidr[1]]
#     key_name = module.bastion.ssh_key_name
#     tags  = {
#           "Name" = "Private host" 
#         }

  
# }

# resource "aws_security_group" "private_host_sg" {
#     description = "SG-private-host"
#     vpc_id      = module.vpc.vpc_id
#     dynamic "ingress" {
#     for_each = var.ingress_ports
#     content {
#         from_port = ingress.value
#         to_port = ingress.value
#         protocol = "tcp"
#         security_groups = [module.bastion.bastion_sg_id]
#         #cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "SG-private-host"
#   }

# }





