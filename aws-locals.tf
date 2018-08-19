/* Locals
 *
 * resource_prefix: Prefix to identify who created the AWS resource.
 *
 * References:
 *  - https://www.terraform.io/docs/configuration/locals.html
 *  - https://github.com/hashicorp/terraform/issues/4084
 */

locals {
  uuid_parts_list = ["${split("-", uuid())}"]
  deployment_id = "${join("", slice(local.uuid_parts_list, 1, 2))}"
  resource_prefix = "${data.aws_canonical_user_id.current.display_name}-${local.deployment_id}-${var.topology_id}"
}
