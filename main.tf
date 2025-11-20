provider "aws" {
  region = var.aws_region
}

#-------------------------------

terraform {
  backend "s3" {
    bucket = "devops-infra-xxxxxx"
    key    = "projectsecret/andrew/terraform.tfstate"
    region = "eu-central-1"
  }
}

#----------------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, { Name = "devops-vpc" })

}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"

  tags = merge(var.common_tags, { Name = "devops-public-subnet" })

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, { Name = "devops-igw" })

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.common_tags, { Name = "devops-public-rt" })

}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


#--------------------------------------------------


data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}


#--------------------------------------------------

resource "aws_instance" "devops_server" {
  ami                    = "ami-004e960cde33f9146" # ubuntu 22.04 in eu-central-1
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  key_name               = var.key_name

  tags = merge(var.common_tags, { Name = "devops-ec2" })

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-sg"
  description = "Allow SSH, HTTP..."
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.allow_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "devops-sg" })

}

#--------------------------------------------------------

# --- random id for bucket---

resource "random_id" "bucket_id" {
  byte_length = 4
}


resource "aws_s3_bucket" "devops_bucket" {
  bucket = "devops-infra-${random_id.bucket_id.hex}"
  acl    = "private"

  tags = merge(var.common_tags, { Name = "devops-s3" })

}

