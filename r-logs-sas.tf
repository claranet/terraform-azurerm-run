# Based on https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/diagnostics-linux
/* This data_source doesn't work for now, because it uses an old Azure Storage API version (2017- instead of 2018-)
data "azurerm_storage_account_sas" "storage-logs-sas-access" {
  connection_string = "${azurerm_storage_account.storage-logs.primary_connection_string}"
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

  count = "${var.create_storage_account_resource == "true" ? 1 : 0}"

  depends_on = ["azurerm_storage_account.storage-logs"]
}
*/

data "external" "generate-storage-sas-token" {
  program = ["bash", "${path.module}/script_sas_stoken.sh"]

  query = {
    storage_account_name = "${join("", azurerm_storage_account.storage-logs.*.name)}"
    token_expiry         = "${var.storage_account_sas_expiry}"
  }

  count = "${var.create_storage_account_resource == "true" ? 1 : 0}"

  depends_on = ["azurerm_storage_account.storage-logs"]
}
