#--------------------------------------------------------------
# Terraform
#
# Find latest AMI for :
#   - Ubuntu 20.4
#   - Amazon Linux 2
#   - Windows Server 2019 Base
#
# can be applied to any region
# Made by Sergey Duvanskiy


provider "aws" {
  region = "eu-central-1"
}

#find latest Ubuntu
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

#find latest Amazon Linux
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#find latest Winows Server 2019 base
data "aws_ami" "latest_windows_server_2019_base" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}
