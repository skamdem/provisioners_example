variable "my_ip" {} // my ip address for sshing on port 22 

variable "region" {
  type        = string
  description = "Default region for aws provider"
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "cidr_block of the vpc in this example"
}

variable "availability_zone" {
  type        = string
  default     = "us-east-1a"
  description = "availability zone of subnet in this example"
}

variable "nginx_version" {
  type        = string
  description = "version of nginx we wish to download and install"
}