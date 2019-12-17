locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  logs_storage_account_name_prefix = var.logs_storage_account_name_prefix != "" ? replace(var.logs_storage_account_name_prefix, "/[a-z0-9]$/", "$0-") : ""

  log_analytics_workspace_name_prefix = var.log_analytics_workspace_name_prefix != "" ? replace(var.log_analytics_workspace_name_prefix, "/[a-z0-9]$/", "$0-") : ""

  log_analytics_name = format(
    "%s%s-%s-%s-%s-log",
    local.log_analytics_workspace_name_prefix != "" ? local.log_analytics_workspace_name_prefix : local.name_prefix,
    var.stack,
    var.client_name,
    var.location_short,
    var.environment,
  )

  storage_default_name_long = replace(
    format(
      "%s%s%s%s",
      local.logs_storage_account_name_prefix != "" ? local.logs_storage_account_name_prefix : local.name_prefix,
      var.stack,
      var.environment,
      var.client_name,
    ),
    "/[._-]/",
    "",
  )
  storage_default_name = coalesce(
    var.logs_storage_account_custom_name,
    substr(
      local.storage_default_name_long,
      0,
      length(local.storage_default_name_long) > 24 ? 23 : -1,
    ),
  )
}

