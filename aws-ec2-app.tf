/*
 * This file contains resources for the "app" AWS EC2 image.
 * All of the resource names are "app".
 */

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

variable "app_ami" {
  description = "App: CentOS Linux 7 1801_1 us-east-1"
  default = "ami-d5bf2caa"
}

variable "app_configuration" {
  description = "Template directory to transform and copy to app AWS instance."
  default = "app-default"
}

variable "app_ec2_count" {
  description = "Number of app role instances"
  default = 1
}

variable "app_instance_type" {
  description = "AWS instance type for app role EC2 nodes"
  default = "t2.micro"
}


# -----------------------------------------------------------------------------
# Data
# -----------------------------------------------------------------------------

data "template_file" "app_environment_variables" {
  template = "${file("${path.module}/data-templates/app/environment_variables.sh")}"
  count = "${var.app_ec2_count}"
  vars {
    app_node_id = "${count.index}"
    internal_ip = "${lookup(var.app_private_ips, count.index)}"
  }
}

# -----------------------------------------------------------------------------
# Resources
# -----------------------------------------------------------------------------

resource "aws_security_group" "app" {
  name = "${var.topology_id}-app"
  description = "Allowable network connections for ${var.topology_id}/app EC2s."
  vpc_id = "${aws_vpc.default.id}"

  # Allow SSH access from anywhere
  ingress {
    from_port = "${var.port_ssh}"
    to_port = "${var.port_ssh}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${local.resource_prefix}-${var.app_configuration}-security-group"
  }
}

resource "template_dir" "app" {
  source_dir = "${path.module}/resource-templates/${var.app_configuration}"
  destination_dir = "${path.cwd}/target/app"
  vars {
    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
  }
}

resource "aws_instance" "app" {
  ami = "${var.app_ami}"
  associate_public_ip_address = true
  count = "${var.app_ec2_count}"
  depends_on = ["aws_internet_gateway.default"]
  ebs_block_device {
    device_name = "/dev/sda1"
    delete_on_termination = true
    volume_size = 50
  }
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "${var.app_instance_type}"
  key_name = "${aws_key_pair.default.id}"
  private_ip = "${lookup(var.app_private_ips, count.index)}"
  subnet_id = "${aws_subnet.default.id}"
  connection {
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.ssh_private_key_path}")}"
  }
  provisioner "file" {
    source      = "${template_dir.app.destination_dir}"
    destination = "/tmp/configuration"
  }
  provisioner "file" {
    source      = "${path.module}/files/${var.app_configuration}/"
    destination = "/tmp/configuration"
  }
  provisioner "file" {
    content = "${element(data.template_file.app_environment_variables.*.rendered, count.index)}"
    destination = "/tmp/configuration/home/centos/environment_variables.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/configuration/home/centos/*.sh",
      "sudo /tmp/configuration/home/centos/configuration.sh",
    ]
  }
  tags {
    Name = "${local.resource_prefix}-${var.app_configuration}-ec2-${count.index}"
  }
  vpc_security_group_ids = ["${aws_security_group.app.id}"]
}

# -----------------------------------------------------------------------------
# Output
# -----------------------------------------------------------------------------

output "private_ips_for_app_nodes" {
  value = ["${aws_instance.app.*.private_ip}"]
}

output "public_ips_for_app_nodes" {
  value = ["${aws_instance.app.*.public_ip}"]
}

output "ssh_example_app_passwordless" {
  value = "ssh centos@${aws_instance.app.0.public_ip}"
}
