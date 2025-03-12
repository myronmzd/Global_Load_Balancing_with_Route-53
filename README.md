# Global_Load_Balancing_with_Route-53
Application Load Balancer (ALB) with EC2 instances in two different AWS regions, but ALBs are regional by design. This means each ALB operates within a single AWS region. However, you can achieve multi-region load balancing using Amazon Route 53.



terraform init -upgrade
terraform validate
terraform plan
terraform fmt -recursive
terraform destroy

terraform apply -auto-approve


terraform init -reconfigure

terraform plan -out=output.tfplan
terraform show output.tfplan > output.txt

vpc is not configure and s3 bucket in west not created and 