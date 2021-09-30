locals {
  name_prefix                = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  base_name                  = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")
  arm_update_management_name = format("%s-%s", local.base_name, "update-management")

  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  tags = merge(local.default_tags, var.extra_tags)

  log_analytics_update_solution = length(regexall("Updates", data.external.log_analytics_update_solution.result.id)) > 0 ? true : false
}
