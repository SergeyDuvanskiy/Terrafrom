provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0a6dc7529cd559185"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("WebServer.sh")
  tags = {
    Name       = "MyWebServer"
    IMAGE_USED = "Amazon Linux"
    owner      = "SergD"
  }

}

resource "aws_security_group" "my_webserver" {
  name        = "my webserver SG"
  description = "Allow HTTP, HTTPS "

  ingress { #like inbound
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { #like inbound
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { #like outbound , in  this one we allow anything
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # - 1 means any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
