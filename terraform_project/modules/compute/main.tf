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

resource "aws_instance" "main_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile = var.instance_profile
  
  network_interface {
    network_interface_id = aws_network_interface.public_eni.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.private_eni.id
    device_index         = 1
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<html><h1>Hello from Region 1!</h1></html>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "WebServerRegion1"
  }
}
