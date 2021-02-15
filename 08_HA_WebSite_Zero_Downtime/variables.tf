variable "region" {
  description = "Enter region name to deploy the environment"
  type        = string
  default     = "eu-central-1"
}

#List of variables for EC2
variable "instance_type" {
  description = "Enter instance type"
  type        = string
  default     = "t2.micro"
}

#List of variables for SG
variable "allowed_ports_sg" {
  description = "List of ports to open for SG"
  type        = list(any)
  default     = ["80", "443"]
}

variable "source_cidr_block_sg" {
  description = "List of CIDRs from  where to connect to servers in SG"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}
