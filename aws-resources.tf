/*
 * This file contains resources for the default "Virtual Private Cloud" (VPC).
 * All of the resource names are "default".
 */


resource "aws_key_pair" "default" {
  key_name = "${local.resource_prefix}-key-pair"
  public_key = "${file("${var.ssh_public_key_path}")}"
}

resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "${local.resource_prefix}-default-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "${local.resource_prefix}-default-gateway"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "default" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
  route_table_id = "${aws_vpc.default.main_route_table_id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${var.aws_availability_zone}"
  cidr_block = "${var.subnet_cidr}"
  map_public_ip_on_launch = true
  tags {
    Name = "${local.resource_prefix}-default-subnet"
  }
}
