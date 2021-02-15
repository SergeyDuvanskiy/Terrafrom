#-------------------------------------------------------------------------------
# High-Available in any Region default VPC
# Create:
#  - Security Group for Web server
#  - Launch configuration for Auto AMI lookup
#  - Auto Scaling group using 2 Availability zones
#  - Classic Load balancer in 2 Availability zones
#
#
# Made by Sergey Duvanskiy
#
#-------------------------------------------------------------------------------

provider "aws" {
  region = var.region
}
# Find data about AZ and Amazon linux AMI image---------------------------------
data "aws_availability_zones" "available" {}
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#-------------------------------------------------------------------------------

# Create Securitygroup for webserver--------------------------------------------
resource "aws_security_group" "my_webserver" {
  name = "Dynamic Security group for WebS"

  dynamic "ingress" {
    for_each = var.allowed_ports_sg
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.source_cidr_block_sg
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # - 1 means any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "web_server_SG"
    owner = "Sergey Duvanskiy"
  }
}
#-------------------------------------------------------------------------------

# Create Launch configuration for Auto AMI lookup-------------------------------
resource "aws_launch_configuration" "web" {
  #name            = "Web-server HA Launch Configuration"
  name_prefix     = "Web-server HA Launch Configurationv -"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.my_webserver.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}
######--------------------------------------------------------------------------

# Create ASG--------------------------------------------------------------------
resource "aws_autoscaling_group" "web" {
  name = "ASG-${aws_launch_configuration.web.name}"
  #name_prefix = "Web-server HA Auto scaling -"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web.name]
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id] #define subnets where CI are started

  dynamic "tag" {
    for_each = {
      Name   = "Web Server in ASG"
      Owner  = "Sergey Duvanskiy"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
#-------------------------------------------------------------------------------

# Create ELB--------------------------------------------------------------------
resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.my_webserver.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    Name = "WebServer-HA-ELB"
  }
}
#-------------------------------------------------------------------------------


#Define default subnetwork id in AZ---------------------------------------------
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}
#-------------------------------------------------------------------------------

output "web_load_balancer_url" {
  value = aws_elb.web.dns_name
}
