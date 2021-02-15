provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "sergey-duvanskiy-terraform-state"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-central-1"
  }
}

#-------------------------------------------------------------------------------

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "sergey-duvanskiy-terraform-state"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#-------------------------------------------------------------------------------
resource "aws_instance" "web-server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_ids[0]
  user_data              = file("WebServer.sh")
  tags = {
    Name = "${var.env}-WebServer"
  }
}


resource "aws_security_group" "my_webserver" {
  name   = "Web Server security group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports_sg
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # - 1 means any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "web-server-sg"
    owner = "Sergey Duvanskiy"
  }
}
#-----------------------------------------------------------------------------
#Outputs----------------------------------------------------------------------

output "web_server_sg_id" {
  value = aws_security_group.my_webserver.id
}

output "web_server_id" {
  value = aws_instance.web-server.id
}

output "web-server_id" {
  value = aws_instance.web-server.public_ip
}
