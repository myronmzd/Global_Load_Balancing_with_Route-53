variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the VPC endpoint"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}
variable "private_route_tables" {
  description = "Private route table ID for the VPC endpoint"
  type        = string
}