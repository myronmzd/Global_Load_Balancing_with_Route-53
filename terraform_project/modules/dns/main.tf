terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
variable "hosted_zone_id" {
  type        = string
  description = "The Route 53 hosted zone ID"
}

variable "instance_public_ip1" {
  type        = string
  description = "Public IP address for the first instance"
}

variable "instance_public_ip2" {
  type        = string
  description = "Public IP address for the second instance"
}

resource "aws_route53_health_check" "region1" {
  ip_address        = var.instance_public_ip1
  port              = 80
  type              = "HTTP"
  resource_path     = "/"  # Add path to check
  request_interval  = "30"
  failure_threshold = "3"

  tags = {
    Name = "region1-health-check"
  }
}

resource "aws_route53_health_check" "region2" {
  ip_address        = var.instance_public_ip2  # Fixed: Use IP of second instance
  port              = 80
  type              = "HTTP"
  resource_path     = "/"  # Add path to check
  request_interval  = "30"
  failure_threshold = "3"

  tags = {
    Name = "region2-health-check"
  }
}

resource "aws_route53_record" "region1" {
  zone_id = var.hosted_zone_id
  name    = "www.myronmzd.com"
  type    = "A"
  ttl     = "300"

  latency_routing_policy {
    region = "us-east-1"
  }

  set_identifier  = "region1"
  records         = [var.instance_public_ip1]
  health_check_id = aws_route53_health_check.region1.id
}

resource "aws_route53_record" "region2" {
  zone_id = var.hosted_zone_id
  name    = "www.myronmzd.com"
  type    = "A"
  ttl     = "300"

  latency_routing_policy {
    region = "us-west-2"
  }

  set_identifier  = "region2"
  records         = [var.instance_public_ip2]  # Fixed: Use IP of second instance
  health_check_id = aws_route53_health_check.region2.id
}