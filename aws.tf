/*
 * This file contains provider information for AWS.
 * In particular:
 *   - AWS region
 */

provider "aws" {
  region = "${var.aws_region}"
}
