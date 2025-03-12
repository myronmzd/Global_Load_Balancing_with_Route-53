terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}


resource "aws_s3_bucket" "mybucket" {
  bucket = "my-bucket-${random_string.suffix.result}"
}

resource "aws_s3_object" "files" {
  for_each = fileset("${path.module}/S3_files/", "**")

  bucket = aws_s3_bucket.mybucket.id
  key    = each.value
  source = "${path.module}/S3_files/${each.value}"
}


resource "aws_vpc_endpoint" "s3_endpoint" {
  depends_on        = [var.vpc_id]
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.private_route_tables]
}