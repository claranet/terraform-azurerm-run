module "log_sas_token" {
  source  = "claranet/storage-sas-token/azurerm"
  version = "4.0.1"

  enabled              = true
  resource_group_name  = var.resource_group_name
  storage_account_name = azurerm_storage_account.storage_logs.name

  sas_token_expiry    = var.logs_storage_account_sas_expiry
  permissions_account = "wlacu"
  resources_types     = "co"
  services            = "bt"
}
