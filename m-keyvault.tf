module "keyvault" {
  source  = "claranet/keyvault/azurerm"
  version = "~> 7.1.0"

  client_name         = var.client_name
  environment         = var.environment
  location            = var.location
  location_short      = var.location_short
  resource_group_name = coalesce(var.keyvault_resource_group_name, var.resource_group_name)
  stack               = var.stack
  tenant_id           = var.tenant_id

  custom_name    = var.keyvault_custom_name
  use_caf_naming = var.use_caf_naming
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix

  sku_name = var.keyvault_sku

  admin_objects_ids  = var.keyvault_admin_objects_ids
  reader_objects_ids = var.keyvault_reader_objects_ids

  enabled_for_deployment          = var.keyvault_enabled_for_deployment
  enabled_for_disk_encryption     = var.keyvault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.keyvault_enabled_for_template_deployment

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
    module.logs.logs_storage_account_id,
  ]

  logs_retention_days     = var.keyvault_logs_retention_days
  logs_categories         = var.keyvault_logs_categories
  logs_metrics_categories = var.keyvault_logs_metrics_categories

  purge_protection_enabled = true

  network_acls = var.keyvault_network_acls

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(var.extra_tags, var.keyvault_extra_tags)
}
