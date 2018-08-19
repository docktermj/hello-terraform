/* Variables
 *
 * This file defines the variables that are used across the Virtual Private Cloud (VPC).
 * A user may override the default values by using a "terraform.tfvars" file and
 * invoking "terraform apply -var-file terraform.tfvars".
 *
 * References:
 *  - https://www.terraform.io/intro/getting-started/variables.html
 */

# ---- AWS --------------------------------------------------------------------

variable "aws_access_key" {
    description = "AWS access key"
    default = "AAAAAAAAAAAAAAAAAAAA"
}

variable "aws_availability_zone" {
  description = "Preferred aws_availability_zone"
  default = "us-east-1c"
}

variable "aws_secret_key" {
    description = "AWS secret key"
    default = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

# ---- Deployment -------------------------------------------------------------

variable "topology_id" {
  description = "Topology name"
  default = "model"
}

# ---- SSH keys and username/password -----------------------------------------

variable "ssh_public_key_path" {
  description = "Location of SSH public key"
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Location of SSH private key"
  default = "~/.ssh/id_rsa"
}

# ---- Ports ------------------------------------------------------------------

variable "port_ssh" {
  description = "SSH port"
  default = 22
}

# ---- VPC --------------------------------------------------------------------

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    description = "CIDR for the subnet"
    default = "10.0.0.0/24"
}

# ---- EC2 --------------------------------------------------------------------

# CentOS reference: https://wiki.centos.org/Cloud/AWS

# Private IP addresses to be used with app node.
variable "app_private_ips" {
  default = {
     "0" = "10.0.0.100"
     "1" = "10.0.0.101"
     "2" = "10.0.0.102"
     "3" = "10.0.0.103"
     "4" = "10.0.0.104"
     "5" = "10.0.0.105"
     "6" = "10.0.0.106"
     "7" = "10.0.0.107"
     "8" = "10.0.0.108"
     "9" = "10.0.0.109"
    "10" = "10.0.0.110"
    "11" = "10.0.0.111"
    "12" = "10.0.0.112"
    "13" = "10.0.0.113"
    "14" = "10.0.0.114"
    "15" = "10.0.0.115"
    "16" = "10.0.0.116"
    "17" = "10.0.0.117"
    "18" = "10.0.0.118"
    "19" = "10.0.0.119"
    "20" = "10.0.0.120"
  }
}
