module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  location       = module.azure_region.location
  location_short = module.azure_region.location_short

  vnet_cidr = ["10.10.10.0/24"]
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  resource_group_name = module.rg.resource_group_name
  location_short      = module.azure_region.location_short
  subnet_cidr_list = [
    "10.10.10.0/27"
  ]
  virtual_network_name = module.vnet.virtual_network_name
}


module "run_common" {
  source  = "claranet/run-common/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  tenant_id = var.azure_tenant_id

  monitoring_function_enabled      = false
  monitoring_function_splunk_token = ""

  keyvault_network_acls = {
    bypass   = "AzureServices"
    ip_rules = []
  }

  keyvault_admin_objects_ids = []

  keyvault_enabled_for_deployment = true
}


module "update_management" {
  source  = "claranet/run-iaas/azurerm//modules/update-center"
  version = "x.x.x"

  location            = module.azure_region.location
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  maintenance_configurations = [
    {
      configuration_name = "config1"
      start_date_time    = "2021-08-21 04:00"
      recur_every        = "1Day"
    },
    {
      configuration_name = "config2"
      start_date_time    = "1900-01-01 03:00"
      recur_every        = "1Week"
    }
  ]
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 3048
}

module "linux_vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  resource_group_name = module.rg.resource_group_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short

  subnet_id = module.subnet.subnet_id

  admin_username  = "claranet"
  ssh_private_key = tls_private_key.ssh_key.private_key_pem
  ssh_public_key  = tls_private_key.ssh_key.public_key_openssh

  azure_monitor_data_collection_rule_id = null
  backup_policy_id                      = null

  diagnostics_storage_account_name      = module.run_common.logs_storage_account_name
  diagnostics_storage_account_sas_token = ""
  log_analytics_workspace_guid          = module.run_common.log_analytics_workspace_guid
  log_analytics_workspace_key           = module.run_common.log_analytics_workspace_primary_key

  vm_size = "Standard_B2ms"
  vm_image = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  patch_mode = "AutomaticByPlatform"
  #maintenance_configuration_ids = [module.run_iaas.update_center_maintenance_configurations["config1"].id, module.run_iaas.update_center_maintenance_configurations["config2"].id]

}

module "windows_vm" {
  source  = "claranet/windows-vm/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  admin_username = "claranet"
  admin_password = "SuP3rStr0ng!"

  public_ip_sku = null

  azure_monitor_data_collection_rule_id = null

  backup_policy_id = null

  diagnostics_storage_account_key  = ""
  diagnostics_storage_account_name = module.run_common.logs_storage_account_name

  key_vault_id = module.run_common.keyvault_id

  log_analytics_workspace_guid = module.run_common.log_analytics_workspace_guid
  log_analytics_workspace_key  = module.run_common.log_analytics_workspace_primary_key

  vm_size = "Standard_B2ms"

  subnet_id  = module.subnet.subnet_id
  patch_mode = "AutomaticByPlatform"
  #maintenance_configuration_ids = [module.run_iaas.update_center_maintenance_configurations["config2"].id]
}
