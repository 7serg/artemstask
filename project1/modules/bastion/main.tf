resource "aws_security_group" "bastion_server" {
  name        = "Web_bastion_sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion-SG"
  }
}


resource "aws_key_pair" "test_ssh_key" {
    key_name = "testing-ssh-key"
    public_key = file(var.public_key)
}

resource "aws_instance" "bastion_vm" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    key_name = aws_key_pair.test_ssh_key.key_name
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.bastion_server.id]
    tags = {
        "Name" = "Bastion host"
    }
}