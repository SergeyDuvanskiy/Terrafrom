provider "aws" {
  region = "eu-central-1"
}

//use remote terraform state in S3 bucket
terraform {
  backend "s3" {
    bucket = "sergey-duvanskiy-terraform-state"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

#-------------------------------------------------------------------------------
#Creating resources-------------------------------------------------------------

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "env" {
  default = "prod"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}
#-------------------------------------------------------------------------------

data "aws_availability_zones" "available" {}

resource "aws_vpc" "prod" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}.vpc"
  }
}

resource "aws_internet_gateway" "main_ig" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name = "${var.env}.igw"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}.public - ${count.index + 1}"
  }
}


resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.prod.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_ig.id
  }

  tags = {
    Name = "${var.env}.route-public-subnet"
  }
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)

}

#-------------------------------------------------------------------------------
#Outputs------------------------------------------------------------------------

output "vpc_id" {
  value = aws_vpc.prod.id
}

output "vpc_cidr" {
  value = aws_vpc.prod.cidr_block
}

output "subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "subnet_cidrs" {
  value = aws_subnet.public_subnets[*].cidr_block
}

output "subnets_info" {
  value = {
    for subnet in aws_subnet.public_subnets :
    subnet.cidr_block => subnet.id
  }
}
