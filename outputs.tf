output "curl_command" {
  value = "curl http://${aws_instance.my_niginx_instance.public_ip}"
}