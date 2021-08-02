locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  base_name                      = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"
  vault_default_name             = "${local.base_name}-recoveryvault"
  vm_policy_default_name         = "${local.base_name}-vm-backup-policy"
  file_share_policy_default_name = "${local.base_name}-fileshare-backup-policy"
}
