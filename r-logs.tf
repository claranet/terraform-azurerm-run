# Log Analytics
resource "azurerm_log_analytics_workspace" "log-workspace" {
  name                = "${coalesce(var.log_analytics_custom_name, "${var.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-log")}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  sku               = "${var.log_analytics_sku}"
  retention_in_days = "${var.log_analytics_retention_in_days}"

  tags = "${merge(local.default_tags, var.extra_tags)}"
}

# Storage account for Logs
resource "azurerm_storage_account" "storage-logs" {
  name = "${local.storage_default_name}"

  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = "${merge(local.default_tags, var.extra_tags, var.storage_account_extra_tags)}"

  count = "${var.create_storage_account_resource == "true" ? 1 : 0}"
}
