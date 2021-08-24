# Azure Backup - Recovery service vault

It includes:
* Azure Backup
    * A Recovery Services Vault to store VM backups ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-overview)).
    * A VM backup policy to assign on VM instances (via the [vm-backup](https://registry.terraform.io/modules/claranet/vm-backup/) module).
    * A file share backup policy to assign on [Storage Account file shares](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction) (via the [backup_protected_file_share](https://www.terraform.io/docs/providers/azurerm/r/backup_protected_file_share.html) terraform resource)
    * A diagnostics settings to manage logging ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-azure-diagnostic-events))

## Version compatibility

| Module version    | Terraform version | AzureRM version |
| ----------------- | ----------------- | --------------- |
| >= 5.x.x          | 0.15.x & 1.0.x    | >= 2.57         |
| >= 4.x.x          | 0.13.x            | >= 2.57         |
| >= 3.x.x          | 0.12.x            | >= 2.0          |
| >= 2.x.x, < 3.x.x | 0.12.x            | <  2.0          |
| <  2.x.x          | 0.11.x            | <  2.0          |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

module "az-backup" {
  source  = "claranet/run-iaas/azurerm//modules/backup"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  extra_tags = {
    foo    = "bar"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_policy_file_share.file_share_backup_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share) | resource |
| [azurerm_backup_policy_vm.vm_backup_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm) | resource |
| [azurerm_monitor_diagnostic_setting.recovery_vault_diagnostics_settings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_recovery_services_vault.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault) | resource |
| [azurerm_monitor_diagnostic_categories.recovery_vault_diagnostics_settings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name | `string` | n/a | yes |
| diagnostics\_settings\_enabled | Enable or disable diagnostics settings on the recovery vault | `bool` | `true` | no |
| environment | Environment name | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| file\_share\_backup\_daily\_policy\_retention | The number of daily file share backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| file\_share\_backup\_monthly | Map to configure the monthly File Share backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_monthly | `any` | `{}` | no |
| file\_share\_backup\_policy\_custom\_name | Azure Backup - File share backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| file\_share\_backup\_policy\_frequency | Specifies the frequency for file\_share backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| file\_share\_backup\_policy\_time | The time of day to perform the file share backup in 24hour format. | `string` | `"04:00"` | no |
| file\_share\_backup\_policy\_timezone | Specifies the timezone for file share backup schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| file\_share\_backup\_weekly | Map to configure the weekly File Share backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_weekly | `any` | `{}` | no |
| file\_share\_backup\_yearly | Map to configure the yearly File Share backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_yearly | `any` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID where the logs are sent | `string` | `null` | no |
| log\_categories | List of log categories. By default this module use a data source to retrieve them:<br>`["CoreAzureBackup", "AddonAzureBackupJobs", "AddonAzureBackupAlerts", "AddonAzureBackupPolicy", "AddonAzureBackupStorage", "AddonAzureBackupProtectedInstance"]` | `list(any)` | `null` | no |
| log\_enabled | Enable or disable logs configuration in diagnostics settings | `bool` | `true` | no |
| log\_eventhub\_authorization\_rule\_id | Event hub authorization rule ID where the logs are sent | `string` | `null` | no |
| log\_retention\_in\_days | Retention time in days for the logs | `number` | `365` | no |
| log\_storage\_account\_id | Storage account ID where the logs are sent | `string` | `null` | no |
| name\_prefix | Name prefix for all resources generated name | `string` | `""` | no |
| recovery\_vault\_custom\_name | Azure Recovery Vault custom name. Empty by default, using naming convention. | `string` | `""` | no |
| recovery\_vault\_extra\_tags | Extra tags to add to recovery vault | `map(string)` | `{}` | no |
| recovery\_vault\_identity\_type | Azure Recovery Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`. | `string` | `"SystemAssigned"` | no |
| recovery\_vault\_sku | Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`. | `string` | `"Standard"` | no |
| resource\_group\_name | Resource Group the resources will belong to | `string` | n/a | yes |
| stack | Stack name | `string` | n/a | yes |
| vm\_backup\_daily\_policy\_retention | The number of daily VM backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| vm\_backup\_monthly | Map to configure the monthly VM backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_monthly | `any` | `{}` | no |
| vm\_backup\_policy\_custom\_name | Azure Backup - VM backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| vm\_backup\_policy\_frequency | Specifies the frequency for VM backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| vm\_backup\_policy\_time | The time of day to perform the VM backup in 24hour format. | `string` | `"04:00"` | no |
| vm\_backup\_policy\_timezone | Specifies the timezone for VM backup schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| vm\_backup\_weekly | Map to configure the weekly VM backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_weekly | `any` | `{}` | no |
| vm\_backup\_yearly | Map to configure the yearly VM backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_yearly | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| file\_share\_backup\_policy\_id | File share Backup policy ID |
| file\_share\_backup\_policy\_name | File share Backup policy name |
| recovery\_vault\_id | Azure Recovery Services Vault ID |
| recovery\_vault\_name | Azure Recovery Services Vault name |
| vm\_backup\_policy\_id | VM Backup policy ID |
| vm\_backup\_policy\_name | VM Backup policy name |
<!-- END_TF_DOCS -->
## Related documentation

- Terraform Azure Recovery Services Vault: [terraform.io/docs/providers/azurerm/r/recovery_services_vault.html](https://www.terraform.io/docs/providers/azurerm/r/recovery_services_vault.html)
- Terraform Azure VM Backup policy: [terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html](https://www.terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html)
- Terraform Azure File Share Backup policy: [terraform.io/docs/providers/azurerm/r/backup_policy_file_share.html](https://www.terraform.io/docs/providers/azurerm/r/backup_policy_file_share.html)
- Terraform Azure Monitor Diagnostics Settings: [terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
