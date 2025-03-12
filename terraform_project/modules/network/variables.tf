variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = string
}

variable "availability_zone_private" {
  description = "The availability zone for the private subnet"
  type        = string
}

variable "public_subnet_cidrs_1" {
  description = "The CIDR block for the first public subnet"
  type        = string
}
variable "public_subnet_cidrs_2" {
  description = "The CIDR block for the first public subnet"
  type        = string
}
variable "availability_zone_public_2" {
  description = "The availability zone for the first public subnet"
  type        = string
}
variable "availability_zone_public_1" {
  description = "The availability zone for the first public subnet"
  type        = string
}

