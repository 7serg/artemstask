variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
    description = "cidr block for VPC"
  
}


variable "vpc_name" {
    type = string
    default = "WEB VPC"
  
}


variable "public_subnets_cidr" {
  description = "Public subnets"
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

}

variable "private_subnets_cidr" {
  description = "Private subnets"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

}

variable "ingress_ports" {
    type = list(number)
    description = "List of allowed ports"
    default = [ 22, 80, 443 ]
}

variable "aws_region" {
  type = string
  default = "eu-central-1"
}