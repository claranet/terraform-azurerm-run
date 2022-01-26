module "log_sas_token" {
  # source  = "claranet/storage-sas-token/azurerm"
  # version = "4.1.0"

  source = "git@git.fr.clara.net:claranet/projects/cloud/azure/terraform/modules/storage-sas-token.git?ref=AZ-674_fix_sa_ds_bug"

  storage_account_name                  = azurerm_storage_account.storage_logs.name
  storage_account_connection_string     = azurerm_storage_account.storage_logs.primary_connection_string
  storage_account_primary_blob_endpoint = azurerm_storage_account.storage_logs.primary_blob_endpoint

  sas_token_expiry    = var.logs_storage_account_sas_expiry
  permissions_account = "wlacu"
  resources_types     = "co"
  services            = "bt"
}
