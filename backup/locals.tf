locals {
  default_tags = {
    env   = "${var.environment}"
    stack = "${var.stack}"
  }

  name_prefix = "${var.name_prefix != "" ? format("%s-", var.name_prefix) : ""}"

  base_name           = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"
  vault_default_name  = "${local.base_name}-recoveryvault"
  policy_default_name = "${local.base_name}-vm-backup-policy"
}
