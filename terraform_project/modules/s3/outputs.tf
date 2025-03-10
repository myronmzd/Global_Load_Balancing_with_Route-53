output "bucket_name" {
  value = aws_s3_bucket.mybucket.id
}

output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}
