/* Data
 *
 * This file contains general "data" definitions.
 *
 * References:
 *  - https://www.terraform.io/docs/configuration/data-sources.html
 */

data "aws_availability_zones" "all" {}

data "aws_caller_identity" "current" {}

data "aws_canonical_user_id" "current" {}
