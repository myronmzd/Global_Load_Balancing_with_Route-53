variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}
variable "public_subnet_ids" {
  description = "The public subnet IDs"
  type        = list(string)
}
variable "security_group_id" {
  description = "The security group ID"
  type        = string
}
variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}
variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}
