# Azure Update Management Center

It includes:

* Azure Update Management Center (preview) ([documentation](https://learn.microsoft.com/en-us/azure/update-center/overview))
* Azure policy assignment to enable periodic assessment ([documentation](https://learn.microsoft.com/en-us/azure/update-center/assessment-options))

## Requirements

* During the preview you have to register for `InGuestAutoAssessmentVMPreview` [documentation](https://learn.microsoft.com/en-us/azure/update-center/enable-machines?tabs=portal-periodic)
* You need to be at least `Contributor` on the subscriptions to use `auto_assessment_enabled` with Update Management Centrer module.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](../../CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl

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

module "linux_vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  resource_group_name = module.rg.name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short

  subnet_id = module.subnet.id

  admin_username  = "claranet"
  ssh_private_key = tls_private_key.ssh_key.private_key_pem
  ssh_public_key  = tls_private_key.ssh_key.public_key_openssh

  azure_monitor_data_collection_rule_id = null
  backup_policy_id                      = null

  diagnostics_storage_account_name      = module.run.logs_storage_account_name
  diagnostics_storage_account_sas_token = ""
  log_analytics_workspace_guid          = module.run.log_analytics_workspace_guid
  log_analytics_workspace_key           = module.run.log_analytics_workspace_primary_key

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
  resource_group_name = module.rg.name

  admin_username = "claranet"
  admin_password = "SuP3rStr0ng!"

  public_ip_sku = null

  azure_monitor_data_collection_rule_id = null

  backup_policy_id = null

  diagnostics_storage_account_key  = ""
  diagnostics_storage_account_name = module.run.logs_storage_account_name

  key_vault_id = module.run.keyvault_id

  log_analytics_workspace_guid = module.run.log_analytics_workspace_guid
  log_analytics_workspace_key  = module.run.log_analytics_workspace_primary_key

  vm_size = "Standard_B2ms"

  subnet_id  = module.subnet.id
  patch_mode = "AutomaticByPlatform"
  #maintenance_configuration_ids = [module.run_iaas.update_center_maintenance_configurations["config2"].id]
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_maintenance_configuration.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_configuration) | resource |
| [azurerm_management_group_policy_assignment.main_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.main_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.main_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.main_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_policy_assignment.main_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) | resource |
| [azurerm_resource_policy_assignment.main_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) | resource |
| [azurerm_subscription_policy_assignment.main_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurerm_subscription_policy_assignment.main_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |

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
| maintenance\_configurations | Maintenance configurations following the [provider's documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/maintenance-configurations). | <pre>list(object({<br/>    configuration_name = string<br/>    start_date_time    = string<br/>    duration           = optional(string, "02:00")<br/>    time_zone          = optional(string, "UTC")<br/>    recur_every        = string<br/>    reboot_setting     = optional(string, "IfRequired")<br/>    windows_classifications_to_include = optional(list(string), [<br/>      "Critical",<br/>      "Definition",<br/>      "FeaturePack",<br/>      "Security",<br/>      "ServicePack",<br/>      "Tools",<br/>      "UpdateRollup",<br/>      "Updates"<br/>    ])<br/>    linux_classifications_to_include = optional(list(string), [<br/>      "Critical",<br/>      "Security",<br/>      "Other",<br/>    ])<br/>    windows_kb_numbers_to_exclude  = optional(list(string), [])<br/>    windows_kb_numbers_to_include  = optional(list(string), [])<br/>    linux_package_names_to_exclude = optional(list(string), [])<br/>    linux_package_names_to_include = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| resource\_group\_name | Resource group to which the resources will belong. | `string` | n/a | yes |
| stack | Stack name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ids | Maintenance Configuration resources IDs. |
| resource | Maintenance Configurations resource object. |
| resource\_group\_policy\_assignment | Resource Group Policy Assignment resource object. |
| resource\_management\_group\_policy\_assignment | Management Group Policy Assignment resource object. |
| resource\_subscription\_policy\_assignment | Subscription Policy Assignment resource object. |
| resource\_virtual\_machine\_policy\_assignment | Virtual Machine Policy Assignment resource object. |
<!-- END_TF_DOCS -->
