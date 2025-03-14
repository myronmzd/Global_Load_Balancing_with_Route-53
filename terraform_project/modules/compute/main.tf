terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
resource "aws_network_interface" "public_eni" {
  subnet_id         = var.public_subnet_id
  security_groups   = [var.security_group_id]
  source_dest_check = true

  tags = {
    Name = "public_eni"
  }
}

resource "aws_network_interface" "private_eni" {
  subnet_id       = var.private_subnet_id
  security_groups = [var.security_group_id]
  tags = {
    Name = "private_eni"
  }
}

resource "aws_eip" "public_ip" {
  domain            = "vpc"
  network_interface = aws_network_interface.public_eni.id # Changed from instance to network_interface

  tags = {
    Name = "public-eip"
  }

  # Add dependency to ensure instance is created first
  depends_on = [aws_instance.main_instance]
}

resource "aws_instance" "main_instance" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = var.instance_profile

  network_interface {
    network_interface_id = aws_network_interface.public_eni.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.private_eni.id
    device_index         = 1
  }
  tags = {
    Name = "WebServerRegion1"
  }
}

resource "null_resource" "setup_web_server" {
  depends_on = [aws_instance.main_instance]
  triggers = {
    instance_id = aws_instance.main_instance.id
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/${var.key_name}.pem")
      host        = aws_eip.public_ip.public_ip
      timeout     = "4m"
    }

    inline = [
      # Update package list okey
      "sudo apt update -y && sudo apt upgrade -y",

      # Install Nginx only if not installed okey
      "if ! command -v nginx &> /dev/null; then sudo apt install -y nginx; fi",

      # Install AWS CLIand unzip  only if not installed okey
      "if ! command -v aws &>/dev/null; then sudo apt update && sudo apt install -y unzip && curl -s 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && unzip -o awscliv2.zip && sudo ./aws/install --update && rm -rf aws awscliv2.zip; fi",


      # Start and enable Nginx if not already running
      "if ! systemctl is-active --quiet nginx; then sudo systemctl start nginx; fi",
      "if ! systemctl is-enabled --quiet nginx; then sudo systemctl enable nginx; fi",

      # Copy file from S3 if it doesn't already exist
      "if [ ! -f /var/www/html/index.html ]; then aws s3 cp s3://${var.bucket_nameed}/home.html /tmp/home.html; fi",
      "if [ ! -f /var/www/html/index.html ]; then sudo mv /tmp/home.html /var/www/html/index.html; fi",

      "sudo rm -rf /var/www/html/index.nginx-debian.html",

      # Set correct permissions
      "sudo chmod 644 /var/www/html/index.html",
      "sudo chown www-data:www-data /var/www/html/index.html"
    ]
  }
}