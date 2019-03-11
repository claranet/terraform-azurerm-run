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

# Based on https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/diagnostics-linux

/* data "azurerm_storage_account_sas" "storage-logs-sas-access" {
  connection_string = "${local.storage_account_connection_string}"
  https_only        = true

  resource_types {
    service   = false
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = true
    file  = false
  }

  start  = "${var.storage_account_sas_start}"
  expiry = "${var.storage_account_sas_expiry}"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = true
    add     = true
    create  = true
    update  = true
    process = false
  }

}
*/

resource "null_resource" "storage-logs-sas-access" {
  triggers {
    uuid = "${var.location_short}${local.storage_default_name}${var.stack}sas"
  }

  provisioner "local-exec" {
    command = <<CMD
az storage account generate-sas \
    --account-name "${join("", azurerm_storage_account.storage-logs.*.name)}" \
    --expiry "${var.storage_account_sas_expiry}" \
    --permissions wlacu \
    --resource-types co \
    --services bt \
    -o tsv
CMD
  }
}
