# Example of Terraform Provisioner

> This project runs a script remotely on an instance after it has been created

## Part one (_main_ branch)
> Create a *provisioner* block inside of resource ***aws_instance***. This entails setting up a *connection* block (also inside of resource ***aws_instance***) to tell the *provisioner* how to connect to the EC2 instance

```
provisioner "remote-exec" {
    inline = [
        "sudo amazon-linux-extras enable nginx${nginx_version}",
        "sudo yum -y install nginx",
        "sudo chmod 777 /usr/share/nginx/html/index.html",
        "echo \"Hello from our nginx server in AWS\" > /usr/share/nginx/html/index.html",        
        "sudo systemctl start nginx",
    ]
}

connection {
    host = aws_instance.nginx.public_ip
    type = "ssh"
    user = "ec2-user"
    private_key = file("nginx_key")
}
```
> Note : in AWS, a *provisioner* block is executed as ***ec2-user*** which is a limited access user. Hence it is necessary to elevate to ***root*** by prefixing our commands with ***sudo*** in the script in order to make system changes (such as installing nginx).

## Part two (_sub_ branch)
> Use attribute *user_data*, inside of resource ***aws_instance***, which is another way of achieving the same outcome.
```
user_data = <<EOF
    #!/bin/bash
    set -ex

    yum update -y
    amazon-linux-extras enable nginx${nginx_version}
    yum -y install nginx
    chmod 777 /usr/share/nginx/html/index.html
    echo "Hello from our nginx server in AWS" > /usr/share/nginx/html/index.html
    systemctl start nginx
    
EOF
```
> Note : 
> * In AWS, _user_data_ is executed as a the ***root user***.  Hence, to make system changes (such as installing nginx), we do not need to prefix our commands with ***sudo*** in the script. 
> * The script starts with a shebang line **#!/bin/bash** so that it will be executed with bash.
> * Setting the **ex** means print each line that is executed and stop upon error
> * The output of the startup script can be examined at **/var/log/cloud-init-output.log**. 