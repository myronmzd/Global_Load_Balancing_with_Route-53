#!/bin/bash

# Exit on any error
set -e

echo "Installing AWS CLI on WSL..."

sudo apt update && sudo apt install -y unzip


# Step 1: Download AWS CLI Installer
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Step 2: Install Unzip (if not already installed)
sudo apt-get update
sudo apt-get install -y unzip

# Step 3: Unzip the AWS CLI package
unzip awscliv2.zip

# Step 4: Install AWS CLI
sudo ./aws/install

# Step 5: Verify Installation
aws --version

# Step 6: Cleanup
rm -rf awscliv2.zip aws

echo "AWS CLI installation completed successfully!"
