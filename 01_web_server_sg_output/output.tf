output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

output "webserver_public_ip" {
  value = aws_instance.my_webserver.public_ip
}

output "webserver_public_dns" {
  value = aws_instance.my_webserver.public_dns
}

output "web_server_sg_id" {
  value = aws_security_group.my_webserver.id
}

output "web_server_sg_arn" {
  value = aws_security_group.my_webserver.arn
}
