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

  depends_on = [aws_instance.my_dbseerver, aws_instance.my_appserver]
}

resource "aws_instance" "my_appserver" {
  ami                    = "ami-0a6dc7529cd559185"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  tags = {
    Name       = "MyAPPServer"
    IMAGE_USED = "Amazon Linux"
    owner      = "SergD"
  }
  depends_on = [aws_instance.my_dbseerver]
}

resource "aws_instance" "my_dbseerver" {
  ami                    = "ami-0a6dc7529cd559185"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  tags = {
    Name       = "MyDBServer"
    IMAGE_USED = "Amazon Linux"
    owner      = "SergD"
  }
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

}
