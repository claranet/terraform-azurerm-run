
module "update_management" {
  source  = "claranet/run/azurerm//modules/update-center"
  version = "x.x.x"

  location            = module.azure_region.location
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

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

# module "linux_vm" {
#   source  = "claranet/linux-vm/azurerm"
#   version = "x.x.x"

#   client_name = var.client_name
#   environment = var.environment
#   stack       = var.stack

#   resource_group_name = module.rg.name
#   location            = module.azure_region.location
#   location_short      = module.azure_region.location_short

#   subnet_id = module.subnet.id

#   admin_username  = "claranet"
#   ssh_private_key = tls_private_key.ssh_key.private_key_pem
#   ssh_public_key  = tls_private_key.ssh_key.public_key_openssh

#   azure_monitor_data_collection_rule_id = null
#   backup_policy_id                      = null

#   diagnostics_storage_account_name      = module.run.logs_storage_account_name
#   diagnostics_storage_account_sas_token = ""
#   log_analytics_workspace_guid          = module.run.log_analytics_workspace_guid
#   log_analytics_workspace_key           = module.run.log_analytics_workspace_primary_key

#   vm_size = "Standard_B2ms"
#   vm_image = {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts"
#     version   = "latest"
#   }

#   patch_mode = "AutomaticByPlatform"
#   #maintenance_configuration_ids = [module.run_iaas.update_center_maintenance_configurations["config1"].id, module.run_iaas.update_center_maintenance_configurations["config2"].id]

# }

# module "windows_vm" {
#   source  = "claranet/windows-vm/azurerm"
#   version = "x.x.x"

#   client_name = var.client_name
#   environment = var.environment
#   stack       = var.stack

#   location            = module.azure_region.location
#   location_short      = module.azure_region.location_short
#   resource_group_name = module.rg.name

#   admin_username = "claranet"
#   admin_password = "SuP3rStr0ng!"

#   public_ip_sku = null

#   azure_monitor_data_collection_rule_id = null

#   backup_policy_id = null

#   diagnostics_storage_account_key  = ""
#   diagnostics_storage_account_name = module.run.logs_storage_account_name

#   key_vault_id = module.run.keyvault_id

#   log_analytics_workspace_guid = module.run.log_analytics_workspace_guid
#   log_analytics_workspace_key  = module.run.log_analytics_workspace_primary_key

#   vm_size = "Standard_B2ms"

#   subnet_id  = module.subnet.id
#   patch_mode = "AutomaticByPlatform"
#   #maintenance_configuration_ids = [module.run_iaas.update_center_maintenance_configurations["config2"].id]
# }
