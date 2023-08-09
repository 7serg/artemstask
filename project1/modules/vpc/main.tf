terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}


data "aws_availability_zones" "available" {
  state = "available"
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

resource "aws_vpc" "web" {
    cidr_block = var.vpc_cidr_block
    tags = {
        "Name" = var.vpc_name
    }
  
}

resource "aws_internet_gateway" "my_web_igw" {
    vpc_id = aws_vpc.web.id
    tags = {
        "Name": "${var.vpc_name} IGW"
    }
  
}

resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnets_cidr)
    vpc_id = aws_vpc.web.id
    cidr_block = element(var.public_subnets_cidr, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        "Name": "${var.vpc_name} public subnet-${count.index + 1}"
    }
    
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.web.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }
  tags = {
    Name = "Public route table for ${var.vpc_name}"
  }
  depends_on = [aws_internet_gateway.my_web_igw]

}


resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}


resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.web.id
    cidr_block = element(var.private_subnets_cidr, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        "Name": "${var.vpc_name} private subnet-${count.index + 1}"
    }
    
}


resource "aws_eip" "for_nat" {
  vpc   = true
}


resource "aws_nat_gateway" "for_private_subnets" {
  allocation_id = aws_eip.for_nat.id
  subnet_id     = aws_subnet.private_subnets[0].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_eip.for_nat]
}


resource "aws_route_table" "privat_rt" {
  vpc_id = aws_vpc.web.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.for_private_subnets.id
  }
  tags = {
    Name = "Private route table for ${var.vpc_name}"
  }
  depends_on = [aws_internet_gateway.my_web_igw]

}


resource "aws_route_table_association" "private_routes" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.privat_rt.id
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}