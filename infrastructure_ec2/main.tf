provider "aws" {
  region = "eu-central-1"
}

# VPC, Subnet, and Security Group
resource "aws_vpc" "react_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "react_subnet" {
  vpc_id     = aws_vpc.react_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true  # Ensure public IP is assigned
}

resource "aws_security_group" "react_sg" {
  name   = "ec2-security-group"
  vpc_id = aws_vpc.react_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "react_igw" {
  vpc_id = aws_vpc.react_vpc.id
}

resource "aws_route_table" "react_route_table" {
  vpc_id = aws_vpc.react_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.react_igw.id
  }
}

resource "aws_route_table_association" "react_rt_assoc" {
  subnet_id      = aws_subnet.react_subnet.id
  route_table_id = aws_route_table.react_route_table.id
}

# EC2 Instance
resource "aws_instance" "react_ec2" {
  ami             = "ami-07eef52105e8a2059"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.react_subnet.id
  security_groups = [aws_security_group.react_sg.name]
  associate_public_ip_address = true
  key_name       = "nginx_c"

  tags = {
    Name = "ReactEC2"
  }
}