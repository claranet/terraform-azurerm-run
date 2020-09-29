locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  subscription_id = data.azurerm_client_config.current.subscription_id

  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  name        = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-dcr"

  data_collection_rule_id = "/subscriptions/${local.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.name}"
}
