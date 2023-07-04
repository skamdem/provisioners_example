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

  #   The connection block tells our provisioner how to
  #   communicate with the instance
  connection {
    host        = aws_instance.nginx_instance.public_ip
    type        = var.connection_protocol
    user        = var.username
    private_key = file(var.private_key_path)
    agent       = "false" //use the local SSH agent for authentication
  }

  #   We run a remote provisioner on the instance after creating it.
  #   In this case, we install nginx and start it. By default,
  #   this should be on port 80

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum -y install nginx",
      "sudo chmod 777 /usr/share/nginx/html/index.html",
      "echo \"Hello from our nginx server in AWS\" > /usr/share/nginx/html/index.html",
      "sudo systemctl start nginx",
    ]
  }
}

# resource "null_resource" "test_ssh_from_windows" {

#   connection {
#     host        = aws_instance.nginx_instance.public_ip
#     type        = var.connection_protocol
#     user        = var.username
#     private_key = file(var.private_key_path)
#     agent       = "false" //use the local SSH agent for authentication
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo amazon-linux-extras enable nginx1",
#       "sudo yum -y install nginx",
#       "sudo chmod 777 /usr/share/nginx/html/index.html",
#       "echo \"Hello from our nginx server in AWS\" > /usr/share/nginx/html/index.html",
#       "sudo systemctl start nginx",
#     ]
#   }

#   provisioner "local-exec" {
#     command = "curl http://${aws_instance.nginx_instance.public_ip}"
#   }
# }
