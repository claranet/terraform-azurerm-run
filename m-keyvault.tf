module "key_vault" {
  source  = "claranet/keyvault/azurerm"
  version = "~> 8.0.0"

  client_name         = var.client_name
  environment         = var.environment
  location            = var.location
  location_short      = var.location_short
  resource_group_name = coalesce(var.key_vault_resource_group_name, var.resource_group_name)
  stack               = var.stack
  tenant_id           = var.tenant_id

  custom_name = var.key_vault_custom_name
  name_prefix = var.name_prefix
  name_suffix = var.name_suffix

  sku_name = var.key_vault_sku

  admin_objects_ids  = var.key_vault_admin_objects_ids
  reader_objects_ids = var.key_vault_reader_objects_ids

  enabled_for_deployment          = var.key_vault_enabled_for_deployment
  enabled_for_disk_encryption     = var.key_vault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment

  purge_protection_enabled   = true
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days

  rbac_authorization_enabled = var.key_vault_rbac_authorization_enabled

  public_network_access_enabled = var.key_vault_public_network_access_enabled

  managed_hardware_security_module_enabled = var.key_vault_managed_hardware_security_module_enabled

  logs_destinations_ids = [
    module.logs.id,
    module.logs.storage_account_id,
  ]
  logs_categories         = var.key_vault_logs_categories
  logs_metrics_categories = var.key_vault_logs_metrics_categories

  network_acls = var.key_vault_network_acls

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(var.extra_tags, var.keyvault_extra_tags)
}

moved {
  from = module.keyvault
  to   = module.key_vault
}
