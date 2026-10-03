output "public_ip" {
  description = "Public IP address of the server"
  value       = aws_instance.web.public_ip
}

output "site_url" {
  description = "Address of the website"
  value       = "http://${aws_instance.web.public_ip}"
}

output "ssh_command" {
  description = "Command to connect to the server"
  value       = "ssh ubuntu@${aws_instance.web.public_ip}"
}
