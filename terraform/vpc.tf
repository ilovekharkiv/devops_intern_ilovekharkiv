resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags       = {
        Name = "Terraform VPC"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
    tags       = {
        Name = "Terraform IG"
    }
}

resource "aws_subnet" "pub_subnet1" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.subnet1_cidr_block
    availability_zone       = "eu-north-1a"
    tags = {
      name = "public subnet #1"
    }
}

resource "aws_subnet" "pub_subnet2" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.subnet2_cidr_block
    availability_zone       = "eu-north-1b"
     tags = {
      name = "public subnet #2"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

      tags = {
      name = "public subnet #2"
    }
}

resource "aws_route_table_association" "route_table_association1" {
    subnet_id      = aws_subnet.pub_subnet1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association2" {
    subnet_id      = aws_subnet.pub_subnet2.id
    route_table_id = aws_route_table.public.id
}