output "alb_dns_name_us_east_1" {
  value = aws_lb.alb_us_east_1.dns_name
}

output "alb_dns_name_us_west_2" {
  value = aws_lb.alb_us_west_2.dns_name
}
