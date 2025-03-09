output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "vpc_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}
