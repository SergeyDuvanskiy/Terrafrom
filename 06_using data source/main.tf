provider "aws" {
  region = "eu-central-1"
}


data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_current_vpcs" {}

#get info about prod VPC
data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}

output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "prod_vpc_cidr" {
  value = data.aws_vpc.prod_vpc.cidr_block
}

#create 2 subnets in prod VPC --------------------------------------------------
resource "aws_subnet" "prod_subnet_1a" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.0.11.0/24"
  tags = {
    Name    = "subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "subnet-1 in ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "prod_subnet_1b" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.0.21.0/24"
  tags = {
    Name    = "subnet-1 in ${data.aws_availability_zones.working.names[1]}"
    Account = "subnet-2 in ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

#------------------------------------------------------------------------------

#get list of availability_zones in region
output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names[1] #this is a list!!!, starting from [0]
}


#get account id
output "data_account_id_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}


#get aws region
output "data_aws_region" {
  value = data.aws_region.current.description
}


#get lsit of VPC ids
output "data_aws_vpcs" {
  value = data.aws_vpcs.my_current_vpcs.ids
}
