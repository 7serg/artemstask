
variable "private_host_ami" {
    type = string
}

variable "instance_type" {
    type = string
    
}

variable "subnet_id" {
  type = string
}

variable "ssh_key_name" {
    type = string
  
}


variable "security_groups" {
    type = list(string)
  
}

variable "vpc_id" {
    type = string
  
}

variable "ingress_ports" {
    type = list(number)

}