output "instance_ip_adds" {
  value = aws_instance.my_server.public_ip
}