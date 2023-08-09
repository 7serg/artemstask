output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.web.id
}

output "public_subnets" {
    value = aws_subnet.public_subnets[*].id 
}

output "private_subnets" {
    value = aws_subnet.private_subnets[*].id 
}