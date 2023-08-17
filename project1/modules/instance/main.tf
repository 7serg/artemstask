resource "aws_instance" "private_host" {
    ami = var.private_host_ami
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.private_host_sg.id]
    subnet_id = var.subnet_id
    key_name = var.ssh_key_name
    tags  = {
          "Name" = "Private host" 
        }

  
}

resource "aws_security_group" "private_host_sg" {
    description = "SG-private-host"
    vpc_id      = var.vpc_id
    dynamic "ingress" {
    for_each = var.ingress_ports
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        security_groups = var.security_groups
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-private-host"
  }

}


# resource "aws_instance" "bastion_vm" {
#     ami = var.ami_id
#     instance_type = var.instance_type
#     subnet_id = var.subnet_id
#     key_name = aws_key_pair.test_ssh_key.key_name
#     associate_public_ip_address = true
#     vpc_security_group_ids = [aws_security_group.bastion_server.id]
#     tags = {
#         "Name" = "Bastion host"
#     }
# }

# module.vpc.private_subnets[var.private_subnets_cidr[1]]