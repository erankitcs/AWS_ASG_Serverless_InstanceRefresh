#!/bin/bash
set -e

# Install necessary dependencies
sudo yum update -y

sudo yum -y install httpd
sudo systemctl enable httpd
cd /var/www/html/
sudo touch hello.html
sudo chmod 777 hello.html
echo "<html><h1>Hello from Custom Web Server AMI- 1.3 from Packer.</h1></html>" > hello.html