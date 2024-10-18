locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  storage_account_name_prefix = var.storage_account_name_prefix == "" ? local.name_prefix : lower(var.storage_account_name_prefix)
  workspace_name_prefix       = var.workspace_name_prefix == "" ? local.name_prefix : lower(var.workspace_name_prefix)

  workspace_name = coalesce(var.workspace_custom_name, data.azurecaf_name.workspace.result)
}
