variable "subnet_id_us_east_1" {
  description = "Subnet ID for the EC2 instances in us-east-1"
  type        = string
}

variable "subnet_id_us_west_2" {
  description = "Subnet ID for the EC2 instances in us-west-2"
  type        = string
}

variable "subnet_ids_us_east_1" {
  description = "Subnet IDs for the ALB in us-east-1"
  type        = list(string)
}

variable "subnet_ids_us_west_2" {
  description = "Subnet IDs for the ALB in us-west-2"
  type        = list(string)
}

variable "vpc_id_us_east_1" {
  description = "VPC ID for us-east-1"
  type        = string
}

variable "vpc_id_us_west_2" {
  description = "VPC ID for us-west-2"
  type        = string
}


variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}