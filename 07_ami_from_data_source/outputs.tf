output "latest_ubuntu_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_amazaon_linux_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "latest_amazon_linux_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "latest_ws_2019_base_id" {
  value = data.aws_ami.latest_windows_server_2019_base.id
}

output "latest_ws_2019_base_name" {
  value = data.aws_ami.latest_windows_server_2019_base.name
}
