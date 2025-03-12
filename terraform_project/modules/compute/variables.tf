variable "ami" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "The public subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "The private subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID"
  type        = string
}
variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
}
  