# Azure Update Management Center

It includes:
* Azure Update Management Center (preview) ([documentation](https://learn.microsoft.com/en-us/azure/update-center/overview))
* Azure policy assignement to enable periodic assessment ([documentation](https://learn.microsoft.com/en-us/azure/update-center/assessment-options))

## Requirements

* During the preview you have to register for `InGuestAutoAssessmentVMPreview` [documentation](https://learn.microsoft.com/en-us/azure/update-center/enable-machines?tabs=portal-periodic)
* You need to be at least `Contributor` on the subscriptions to use `auto_assessment_enabled` with Update Management Centrer module.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](../../CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
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
  source  = "claranet/run/azurerm"
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

  update_center_enabled = false

  keyvault_network_acls = {
    bypass   = "AzureServices"
    ip_rules = []
  }

  keyvault_admin_objects_ids = []

  keyvault_enabled_for_deployment = true
}


module "update_management" {
  source  = "claranet/run/azurerm//modules/update-center"
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
```

## Providers

| Name | Version |
|------|---------|
| azapi | ~> 1.0 |
| azurerm | ~> 3.22 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.maintenance_configurations](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_management_group_policy_assignment.update_check_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.update_check_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.update_check_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.update_check_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_policy_assignment.update_check_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) | resource |
| [azurerm_resource_policy_assignment.update_check_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) | resource |
| [azurerm_subscription_policy_assignment.update_check_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurerm_subscription_policy_assignment.update_check_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_assessment\_enabled | Enable auto-assessment (every 24 hours) for OS updates on native Azure virtual machines by assigning Azure Policy. | `bool` | `true` | no |
| auto\_assessment\_exclusions | Exclude some resources from auto-assessment. | `list(string)` | `[]` | no |
| auto\_assessment\_scopes | Scope to assign the Azure Policy for auto-assessment. Can be Management Groups, Subscriptions, Resource Groups or Virtual Machines. | `list(string)` | `[]` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Environment name. | `string` | n/a | yes |
| extra\_tags | Additional tags to add | `map(string)` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| maintenance\_configurations | Maintenance configurations. https://learn.microsoft.com/en-us/azure/virtual-machines/maintenance-configurations | <pre>list(object({<br>    configuration_name = string<br>    start_date_time    = string<br>    duration           = optional(string, "02:00")<br>    time_zone          = optional(string, "UTC")<br>    recur_every        = string<br>    reboot_setting     = optional(string, "IfRequired")<br>    windows_classifications_to_include = optional(list(string), [<br>      "Critical",<br>      "Definition",<br>      "FeaturePack",<br>      "Security",<br>      "ServicePack",<br>      "Tools",<br>      "UpdateRollup",<br>      "Updates"<br>    ])<br>    linux_classifications_to_include = optional(list(string), [<br>      "Critical",<br>      "Security",<br>      "Other",<br>    ])<br>    windows_kb_ids_to_exclude      = optional(list(string), [])<br>    linux_package_names_to_exclude = optional(list(string), [])<br>  }))</pre> | `[]` | no |
| resource\_group\_name | Resource Group the resources will belong to. | `string` | n/a | yes |
| stack | Stack name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| maintenance\_configurations | Maintenance Configurations information. |
<!-- END_TF_DOCS -->
