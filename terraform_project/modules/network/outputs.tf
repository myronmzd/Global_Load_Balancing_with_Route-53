output "vpc_id" {
  value = aws_vpc.main.id
}
output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "security_groups_id" {
  value = aws_security_group.ec2_sg.id
}
output "private_route_table" {
  value = aws_route_table.private_route_table.id
}

output "public_subnet_idsss" {
  value = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnet1.id
}
