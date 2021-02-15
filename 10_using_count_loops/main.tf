provider "aws" {
  region = "eu-central-1"
}

variable "aws_users" {
  default = ["Serg", "John", "Piotr", "Max"]
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-0a6dc7529cd559185"
  instance_type = "t2.micro"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}

output "created_iam_users_ids" {
  value = aws_iam_user.users[*].id
}

output "created_iam_users_custom" {
  value = [
    for user in aws_iam_user.users :
    "Username: ${user.name} has ARN : ${user.arn}"
  ]
}

output "created_users_map" {
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id //uniq_id : user_id
  }
}

output "length_user_name" {
  value = [
    for item in aws_iam_user.users :
    item.name
    if length(item.name) == 4
  ]
}

output "servers_all" {
  value = {
    for server in aws_instance.servers :
    server.id => server.public_ip //print instance id : public_ip
  }
}
