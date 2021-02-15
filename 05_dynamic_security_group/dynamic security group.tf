provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "my_webserver" {
  name = "Dynamic Security group"


  dynamic "ingress" {
    for_each = ["80", "443", "8080"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress { #like outbound , in  this one we allow anything
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # - 1 means any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "DEV_SERVER_SG"
  }
}
