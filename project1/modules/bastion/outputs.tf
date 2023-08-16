output "bastion_server_ip" {
  value = aws_instance.bastion_vm.public_ip
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_server.id
}