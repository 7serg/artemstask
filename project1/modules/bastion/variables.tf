variable "ami_id" {
    description = "AMI ID to provision"
    type = string
    default = "ami-0e00e602389e469a3"
}


variable "instance_type" {
  description = "Instance type"
  type = string
  default = "t2.micro"
}

variable "public_key" {

}

variable "is_bastion" {
    type = bool
    description = "Launches bastion server if true"
    default = false
}

variable "vpc_id" {

}

variable "subnet_id" {
  
}

variable "ingress_ports" {
    type = list(number)
    description = "List of allowed ports"
    default = [22]
}