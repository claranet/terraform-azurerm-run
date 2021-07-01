locals {
  default_name = lower("${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  arm_patch_mngt_name = format("%s-%s", local.default_name, "patch-mgt")
}
