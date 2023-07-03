# compute instances of aws provider

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
  key_name               = aws_key_pair.keypair.key_name

  tags = {
    Name        = "prov-example"
    "Terraform" = "Yes"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx${var.nginx_version}",
      "sudo yum -y install nginx",
      "sudo chmod 777 /usr/share/nginx/html/index.html",
      "echo \"Hello from our nginx server in AWS\" > /usr/share/nginx/html/index.html",
      "sudo systemctl start nginx",
    ]
  }

  connection {
    host        = aws_instance.nginx_instance.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    agent       = "true"
  }
}