output "curl_command" {
  value = "curl http://${aws_instance.nginx_instance.public_ip}"
}