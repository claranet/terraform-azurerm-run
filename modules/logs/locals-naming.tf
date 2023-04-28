locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  logs_storage_account_name_prefix    = var.logs_storage_account_name_prefix == "" ? local.name_prefix : lower(var.logs_storage_account_name_prefix)
  log_analytics_workspace_name_prefix = var.log_analytics_workspace_name_prefix == "" ? local.name_prefix : lower(var.log_analytics_workspace_name_prefix)

  log_analytics_name = coalesce(var.log_analytics_workspace_custom_name, data.azurecaf_name.log_analytics_workspace.result)
}
