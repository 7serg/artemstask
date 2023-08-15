output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.web.id
}

output "public_subnets" {
    value = {
        for k,v in aws_subnet.public_subnets : k => v.id
  }
}

output "private_subnets" {
       value = {
        for k,v in aws_subnet.private_subnets : k => v.id
  }
}

# output "nat_gateway_id"{
#     value = {
#         for k,v in aws_nat_gateway.for_private_subnets : k => v.id
#     }
# }