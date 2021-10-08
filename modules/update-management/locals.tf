locals {
  name_prefix                           = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  base_name                             = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")
  arm_update_management_name            = format("%s-%s", local.base_name, "update-management")
  title_name_prefix                     = replace(title(lower(local.name_prefix)), "-", " ")
  linux_update_management_config_name   = format("%s%s", local.title_name_prefix, var.linux_update_management_configuration_name)
  windows_update_management_config_name = format("%s%s", local.title_name_prefix, var.windows_update_management_configuration_name)

  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  tags = merge(local.default_tags, var.extra_tags)
}
