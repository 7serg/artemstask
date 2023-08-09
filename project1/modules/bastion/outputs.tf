output "bastion_server_ip" {
  value = aws_instance.bastion_vm.public_ip
}