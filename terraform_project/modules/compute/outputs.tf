output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.main_instance.id
}

output "public_ip" {
  description = "Public IP of the first EC2 instance"
  value       = aws_eip.public_ip.public_ip  # ✅ Use Elastic IP output
}
output "private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.main_instance.private_ip
}
