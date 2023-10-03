terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    "Name" = "Production ${var.main_vpc_name}"
  }
}

# create subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.web_subnet_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "main_vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.main_vpc_name} igw"
  }
  
}

resource "aws_default_route_table" "main_vpc_default_rtb" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_vpc_igw.id
  }

  tags = {
    Name = "${var.main_vpc_name} rtb"
  }
}

resource "aws_default_security_group" "deafult_vpc_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    
  }
}

# resource "aws_vpc" "my_vpc" {
#   cidr_block = "192.168.0.0/16"

#   tags = {
#     "Name" = "My VPC"
#   }
# }