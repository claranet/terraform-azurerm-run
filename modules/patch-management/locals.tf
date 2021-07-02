locals {
  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  base_name = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  arm_patch_mngt_name = format("%s-%s", local.base_name, "patch-mgt")
}
