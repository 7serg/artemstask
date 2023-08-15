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

locals  {
  az_names = data.aws_availability_zones.available.names
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
    for_each = toset(var.public_subnets_cidr)
    vpc_id = aws_vpc.web.id
    cidr_block = each.key
    availability_zone = local.az_names[index(var.public_subnets_cidr, each.key)]
    tags = {
        "Name": "${var.vpc_name} public subnet-${index(var.public_subnets_cidr, each.key) + 1}"
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
  for_each = aws_subnet.public_subnets
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = each.value.id
}


resource "aws_subnet" "private_subnets" {
    for_each = toset(var.private_subnets_cidr)
    vpc_id = aws_vpc.web.id
    cidr_block = each.key
    availability_zone = local.az_names[index(var.private_subnets_cidr, each.key)]
    tags = {
        "Name": "${var.vpc_name} private subnet-${index(var.private_subnets_cidr, each.key) +1}"
    }
    
}


resource "aws_eip" "for_nat" {
  vpc   = true
}


resource "aws_nat_gateway" "for_private_subnets" {
  allocation_id = aws_eip.for_nat.id
  subnet_id     = aws_subnet.private_subnets[var.private_subnets_cidr[0]].id
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
  for_each          =  aws_subnet.private_subnets
  route_table_id = aws_route_table.privat_rt.id
  subnet_id      = each.value.id
}

