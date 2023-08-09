variable "vpc_cidr_block" {
    type = string
    description = "cidr block for VPC"  
}


variable "vpc_name" {
    type = string    
}


variable "public_subnets_cidr" {
  description = "Public subnets"
}

variable "private_subnets_cidr" {
  description = "Private subnets"
}

variable "ingress_ports" {
    type = list(number)
    description = "List of allowed ports"
    default = [22]
}

variable "aws_region" {
  type = string
  default = "eu-central-1"
}


# variable "vpc_id" {
  
# }

# variable "subnet_id" {
#     type = string 
# }

variable "public_key" {
  
}

variable "ami_id" {
    type = string 
}

variable "instance_type" {
    type = string  
}