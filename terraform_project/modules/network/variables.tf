variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = string
}

variable "availability_zone_pravate" {
  description = "The availability zone for the private subnet"
  type        = string
}
variable "availability_zone_public" {
  description = "The availability zone for the public subnet"
  type        = string
}
