# variables definition for "provisioners_example" project

# General variables
variable "region" {
  type        = string
  description = "Default region for aws provider"
}

variable "cidr_block" {
  type        = string
  description = "cidr_block of the vpc in this example"
}

variable "availability_zone" {
  type        = string
  description = "availability zone of subnet in this example"
}

# EC2 variables
variable "my_ip" {} // my ip address for sshing on port 22 

variable "nginx_version" {
  type        = string
  description = "version of nginx we wish to download and install"
}

variable "public_key" {
  type        = string
  description = "public key to ssh into nginx server"
}

variable "username" {
  type        = string
  description = "user name for connecting"
}

variable "connection_protocol" {
  type        = string
  description = "protocol used for connecting"
}

variable "private_key_path" {
  type        = string
  description = "path to private key"
}

variable "instance_type" {
  type        = string
  description = "type of instance"
}