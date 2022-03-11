locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  arm_update_management_name            = azurecaf_name.update.result
  title_name_prefix                     = replace(title(lower(local.name_prefix)), "-", " ")
  linux_update_management_config_name   = format("%s%s", local.title_name_prefix, var.linux_update_management_configuration_name)
  windows_update_management_config_name = format("%s%s", local.title_name_prefix, var.windows_update_management_configuration_name)
}
