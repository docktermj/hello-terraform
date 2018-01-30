provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-2757f631"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.us-east-1e-public.id}"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "us-east-1e-public" {
  vpc_id = "${aws_vpc.example.id}"
  cidr_block = "10.0.1.0/25"
  availability_zone = "us-east-1e"
}