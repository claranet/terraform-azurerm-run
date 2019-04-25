# Log Analytics
resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = "${coalesce(var.log_analytics_workspace_custom_name, local.log_analytics_name)}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  sku               = "${var.log_analytics_workspace_sku}"
  retention_in_days = "${var.log_analytics_workspace_retention_in_days}"

  tags = "${merge(local.default_tags, var.extra_tags, var.log_analytics_workspace_extra_tags)}"
}

# Storage account for Logs
resource "azurerm_storage_account" "storage_logs" {
  name = "${local.storage_default_name}"

  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = "${merge(local.default_tags, var.extra_tags, var.logs_storage_account_extra_tags)}"
}

# Container for App Services logs which is not automatically created
resource "azurerm_storage_container" "container_webapps" {
  name                 = "${var.logs_storage_acount_appservices_container_name}"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_name = "${azurerm_storage_account.storage_logs.name}"
}
