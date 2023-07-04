# compute instances of aws provider

# data "aws_key_pair" "keypair" {
#   key_name = "some_key"
#   filter {
#     name   = "key-name"
#     values = ["some_key"]
#   }
# }
resource "aws_key_pair" "keypair" {
  key_name   = "my_nginx_key"
  public_key = var.public_key
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

resource "aws_instance" "nginx_instance" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = resource.aws_key_pair.keypair.key_name

  tags = {
    Name        = "${local.resources_tag}"
    "Terraform" = "Yes"
  }

  #   AWS built-in way of running the script on the instance upon starting it.
  #   The script installs nginx and starts it. By default,
  #   this should be on port 80
  user_data = <<EOF
    #!/bin/bash
    set -ex

    yum update -y
    amazon-linux-extras enable nginx1
    yum -y install nginx
    chmod 777 /usr/share/nginx/html/index.html
    echo "Hello from nginx on AWS with USER DATA" > /usr/share/nginx/html/index.html
    systemctl start nginx
  EOF
}

