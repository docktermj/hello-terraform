/* Output
 *
 * This file defines the output that is shown after running
 * "terraform apply ..." or "terraform output".
 *
 * References:
 * - https://www.terraform.io/intro/getting-started/outputs.html
 * - https://www.terraform.io/docs/configuration/outputs.html
 */

output "resource_prefix" {
  value = "${local.resource_prefix}"
}
