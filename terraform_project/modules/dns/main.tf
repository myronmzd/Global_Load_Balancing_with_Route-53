resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = var.alb_dns_name_us_east_1
    zone_id                = var.alb_zone_id_us_east_1
    evaluate_target_health = true
  }
  set_identifier = "us-east-1"
  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "www_failover" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = var.alb_dns_name_us_west_1
    zone_id                = var.alb_zone_id_us_west_1
    evaluate_target_health = true
  }

  set_identifier = "us-west-1"
  failover_routing_policy {
    type = "SECONDARY"
  }
}
