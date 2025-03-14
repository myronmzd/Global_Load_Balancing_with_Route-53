terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


resource "aws_route53_health_check" "region1" {
  ip_address        = var.instance_public_ip1
  port              = 80
  type              = "HTTP"
  request_interval  = "30"
  failure_threshold = "3"

  tags = {
    Name = "region1-health-check"
  }
}

resource "aws_route53_health_check" "region2" {
  ip_address        = var.instance_public_ip1
  port              = 80
  type              = "HTTP"
  request_interval  = "30"
  failure_threshold = "3"

  tags = {
    Name = "region2-health-check"
  }
}
# Latency-based routing records
resource "aws_route53_record" "region1" {
  zone_id = var.hosted_zone_id # Fixed: Use the zone_id from the primary zone
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
  zone_id = var.hosted_zone_id # Fixed: Use the zone_id from the primary zone
  name    = "www.myronmzd.com"
  type    = "A"
  ttl     = "300"

  latency_routing_policy {
    region = "us-west-2"
  }

  set_identifier  = "region2"
  records         = [var.instance_public_ip1]
  health_check_id = aws_route53_health_check.region2.id
}