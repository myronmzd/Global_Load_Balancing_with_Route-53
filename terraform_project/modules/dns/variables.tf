variable "domain_name" {
  description = "Domain name for Route 53"
  type        = string
}

variable "alb_dns_name_us_east_1" {
  description = "DNS name of the ALB in us-east-1"
  type        = string
}

variable "alb_zone_id_us_east_1" {
  description = "Zone ID of the ALB in us-east-1"
  type        = string
}

variable "alb_dns_name_us_west_2" {
  description = "DNS name of the ALB in us-west-2"
  type        = string
}

variable "alb_zone_id_us_west_2" {
  description = "Zone ID of the ALB in us-west-2"
  type        = string
}
