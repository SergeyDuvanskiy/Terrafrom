provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_ubuntu" {

  ami           = "ami-0502e817a62226e03"
  instance_type = "t2.micro"

  tags = {
    Name    = "My Ubuntu server"
    Owner   = "SD"
    Project = "Terraform study"
  }
}

resource "aws_instance" "My_AmazonLinux" {
  ami           = "ami-0a6dc7529cd559185"
  instance_type = "t2.micro"
  tags = {
    Name    = "My AmazonLinux server"
    Owner   = "SD"
    Project = "Terraform study"
  }
}
