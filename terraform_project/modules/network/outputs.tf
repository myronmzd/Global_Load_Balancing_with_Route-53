output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "security_group_ids" {
  value = aws_security_group.ec2_sg[*].id
}
output "private_route_table" {
  value = aws_route_table.private_route_table.id
}