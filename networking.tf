resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = aws_vpc.vpc.cidr_block
  map_public_ip_on_launch = true // instances launched into the subnet should be assigned a public IP address
  availability_zone       = var.availability_zone
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "gateway_route" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "provisioners_example_sg" {
  name   = "provisioners-example-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 22
    to_port   = 22
  }
}