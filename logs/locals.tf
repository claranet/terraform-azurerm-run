locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  name_prefix = var.name_prefix != "" ? format("%s-", var.name_prefix) : ""

  log_analytics_name = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-log"

  storage_default_name_long = replace(
    format(
      "%s%s%s%s",
      coalesce(var.logs_storage_account_custom_name, var.logs_storage_account_name_prefix, var.name_prefix),
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

