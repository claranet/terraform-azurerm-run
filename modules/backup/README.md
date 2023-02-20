# Azure Backup

This sub-module includes:

* A Recovery Services Vault to store VM & File shares backups if enabled ([documentation](https://learn.microsoft.com/en-us/azure/backup/backup-azure-recovery-services-vault-overview)).
* A Backup Vault to store PostgreSQL, Managed Disks and Storage blob if enabled ([documentation](https://learn.microsoft.com/en-us/azure/backup/backup-vault-overview)).
* A VM backup policy to assign on VM instances via the [vm-backup](https://registry.terraform.io/modules/claranet/vm-backup/) module.
* A File share backup policy to assign on [Storage Account file shares](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction)
via the [storage-file](https://registry.terraform.io/modules/claranet/storage-file/azurerm/) module or the
[backup_protected_file_share](https://www.terraform.io/docs/providers/azurerm/r/backup_protected_file_share.html) terraform resource
* Diagnostics settings to manage logging ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-azure-diagnostic-events))

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
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 6.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_policy_file_share.file_share_backup_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share) | resource |
| [azurerm_backup_policy_vm.vm_backup_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm) | resource |
| [azurerm_data_protection_backup_policy_blob_storage.blob_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_blob_storage) | resource |
| [azurerm_data_protection_backup_policy_disk.disk_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_disk) | resource |
| [azurerm_data_protection_backup_policy_postgresql.pgsql_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_postgresql) | resource |
| [azurerm_data_protection_backup_vault.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_vault) | resource |
| [azurerm_recovery_services_vault.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault) | resource |
| [azurecaf_name.backup_vault](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.recovery_vault](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup\_file\_share\_enabled | Whether the File Share backup is enabled. | `bool` | `true` | no |
| backup\_managed\_disk\_enabled | Whether the Managed Disk backup is enabled. | `bool` | `true` | no |
| backup\_postgresql\_enabled | Whether the PostgreSQL backup is enabled. | `bool` | `true` | no |
| backup\_storage\_blob\_enabled | Whether the Storage blob backup is enabled. | `bool` | `true` | no |
| backup\_vault\_custom\_name | Azure Backup Vault custom name. Empty by default, using naming convention. | `string` | `""` | no |
| backup\_vault\_datastore\_type | Type of data store used for the Backup Vault. | `string` | `"VaultStore"` | no |
| backup\_vault\_extra\_tags | Extra tags to add to Backup Vault. | `map(string)` | `{}` | no |
| backup\_vault\_geo\_redundancy\_enabled | Whether the geo redundancy is enabled no the Backup Vault. | `bool` | `true` | no |
| backup\_vault\_identity\_type | Azure Backup Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`. | `string` | `"SystemAssigned"` | no |
| backup\_vm\_enabled | Whether the Virtual Machines backup is enabled. | `bool` | `true` | no |
| client\_name | Client name | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Environment name | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| file\_share\_backup\_daily\_policy\_retention | The number of daily file share backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| file\_share\_backup\_monthly\_retention | Map to configure the monthly File Share backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_monthly | <pre>object({<br>    count    = number,<br>    weekdays = string,<br>    weeks    = string,<br>  })</pre> | `null` | no |
| file\_share\_backup\_policy\_custom\_name | Azure Backup - File share backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| file\_share\_backup\_policy\_frequency | Specifies the frequency for file\_share backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| file\_share\_backup\_policy\_time | The time of day to perform the file share backup in 24hour format. | `string` | `"04:00"` | no |
| file\_share\_backup\_policy\_timezone | Specifies the timezone for file share backup schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| file\_share\_backup\_weekly\_retention | Map to configure the weekly File Share backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_weekly | <pre>object({<br>    count    = number,<br>    weekdays = string,<br>  })</pre> | `null` | no |
| file\_share\_backup\_yearly\_retention | Map to configure the yearly File Share backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_yearly | <pre>object({<br>    count    = number,<br>    weekdays = string,<br>    weeks    = string,<br>    months   = string,<br>  })</pre> | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| managed\_disk\_backup\_daily\_policy\_retention\_in\_days | The number of days to keep the first daily Managed Disk backup. | `number` | `null` | no |
| managed\_disk\_backup\_policy\_custom\_name | Azure Backup - Managed disk backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| managed\_disk\_backup\_policy\_interval\_in\_hours | The Managed Disk backup interval in hours. | `string` | `24` | no |
| managed\_disk\_backup\_policy\_retention\_in\_days | The number of days to keep the Managed Disk backup. | `number` | `30` | no |
| managed\_disk\_backup\_policy\_time | The time of day to perform the Managed Disk backup in 24 hours format (eg 04:00). | `string` | `"04:00"` | no |
| managed\_disk\_backup\_weekly\_policy\_retention\_in\_weeks | The number of weeks to keep the first weekly Managed Disk backup. | `number` | `null` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| postgresql\_backup\_daily\_policy\_retention\_in\_days | The number of days to keep the first daily Postgresql backup. | `number` | `null` | no |
| postgresql\_backup\_monthly\_policy\_retention\_in\_months | The number of months to keep the first monthly Postgresql backup. | `number` | `null` | no |
| postgresql\_backup\_policy\_custom\_name | Azure Backup - PostgreSQL backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| postgresql\_backup\_policy\_interval\_in\_hours | The Postgresql backup interval in hours. | `string` | `24` | no |
| postgresql\_backup\_policy\_retention\_in\_days | The number of days to keep the Postgresql backup. | `number` | `30` | no |
| postgresql\_backup\_policy\_time | The time of day to perform the Postgresql backup in 24 hours format (eg 04:00). | `string` | `"04:00"` | no |
| postgresql\_backup\_weekly\_policy\_retention\_in\_weeks | The number of weeks to keep the first weekly Postgresql backup. | `number` | `null` | no |
| recovery\_vault\_cross\_region\_restore\_enabled | Is cross region restore enabled for this Vault? Only can be `true`, when `storage_mode_type` is `GeoRedundant`. Defaults to `false`. | `bool` | `true` | no |
| recovery\_vault\_custom\_name | Azure Recovery Vault custom name. Empty by default, using naming convention. | `string` | `""` | no |
| recovery\_vault\_extra\_tags | Extra tags to add to Recovery Vault. | `map(string)` | `{}` | no |
| recovery\_vault\_identity\_type | Azure Recovery Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`. | `string` | `"SystemAssigned"` | no |
| recovery\_vault\_sku | Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`. | `string` | `"Standard"` | no |
| recovery\_vault\_soft\_delete\_enabled | Is soft delete enable for this Vault? Defaults to `true`. | `bool` | `true` | no |
| recovery\_vault\_storage\_mode\_type | The storage type of the Recovery Services Vault. Possible values are `GeoRedundant`, `LocallyRedundant` and `ZoneRedundant`. Defaults to `GeoRedundant`. | `string` | `"GeoRedundant"` | no |
| resource\_group\_name | Resource Group the resources will belong to | `string` | n/a | yes |
| stack | Stack name | `string` | n/a | yes |
| storage\_blob\_backup\_policy\_custom\_name | Azure Backup - Storage blob backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| storage\_blob\_backup\_policy\_retention\_in\_days | The number of days to keep the Storage blob backup. | `number` | `30` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `recovery_vault_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| vm\_backup\_daily\_policy\_retention | The number of daily VM backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| vm\_backup\_monthly\_retention | Map to configure the monthly VM backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_monthly | <pre>object({<br>    count    = number,<br>    weekdays = string,<br>    weeks    = string,<br>  })</pre> | `null` | no |
| vm\_backup\_policy\_custom\_name | Azure Backup - VM backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| vm\_backup\_policy\_frequency | Specifies the frequency for VM backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| vm\_backup\_policy\_time | The time of day to perform the VM backup in 24hour format. | `string` | `"04:00"` | no |
| vm\_backup\_policy\_timezone | Specifies the timezone for VM backup schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| vm\_backup\_weekly\_retention | Map to configure the weekly VM backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_weekly | <pre>object({<br>    count    = number,<br>    weekdays = string,<br>  })</pre> | `null` | no |
| vm\_backup\_yearly\_retention | Map to configure the yearly VM backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_yearly | <pre>object({<br>    count    = number,<br>    weekdays = string,<br>    weeks    = string,<br>    months   = string,<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| backup\_vault\_id | Azure Backup Vault ID. |
| backup\_vault\_identity | Azure Backup Services Vault identity. |
| backup\_vault\_name | Azure Backup Vault name. |
| file\_share\_backup\_policy\_id | File share Backup policy ID. |
| file\_share\_backup\_policy\_name | File share Backup policy name. |
| managed\_disk\_backup\_policy\_id | Managed disk Backup policy ID. |
| postgresql\_backup\_policy\_id | PostgreSQL Backup policy ID. |
| recovery\_vault\_id | Azure Recovery Services Vault ID. |
| recovery\_vault\_identity | Azure Recovery Services Vault identity. |
| recovery\_vault\_name | Azure Recovery Services Vault name. |
| storage\_blob\_backup\_policy\_id | Storage blob Backup policy ID. |
| vm\_backup\_policy\_id | VM Backup policy ID. |
| vm\_backup\_policy\_name | VM Backup policy name |
<!-- END_TF_DOCS -->

## Related documentation

- Terraform Azure Recovery Services Vault: [terraform.io/docs/providers/azurerm/r/recovery_services_vault.html](https://www.terraform.io/docs/providers/azurerm/r/recovery_services_vault.html)
- Terraform Azure VM Backup policy: [terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html](https://www.terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html)
- Terraform Azure File Share Backup policy: [terraform.io/docs/providers/azurerm/r/backup_policy_file_share.html](https://www.terraform.io/docs/providers/azurerm/r/backup_policy_file_share.html)
- Terraform Azure Monitor Diagnostics Settings: [terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
