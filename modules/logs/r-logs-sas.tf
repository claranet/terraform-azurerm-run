module "log_sas_token" {
  source  = "claranet/storage-sas-token/azurerm"
  version = "4.2.0"

  storage_account_connection_string = module.storage_logs.storage_account_properties.primary_connection_string

  sas_token_expiry    = var.logs_storage_account_sas_expiry
  permissions_account = "wlacu"
  resources_types     = "co"
  services            = "bt"
}
