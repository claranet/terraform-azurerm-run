# Azure Backup

This sub-module includes:

* A Recovery Services Vault to store VM & File shares backups if enabled ([documentation](https://learn.microsoft.com/en-us/azure/backup/backup-azure-recovery-services-vault-overview)).
* A Backup Vault to store PostgreSQL, Managed Disks and Storage blob if enabled ([documentation](https://learn.microsoft.com/en-us/azure/backup/backup-vault-overview)).
* A VM backup policy to assign on VM instances via the [vm-backup](https://registry.terraform.io/modules/claranet/vm-backup/) module.
* A File share backup policy to assign on [Storage Account file shares](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction)
via the [storage-file](https://registry.terraform.io/modules/claranet/storage-file/azurerm/) module or the
[backup_protected_file_share](https://www.terraform.io/docs/providers/azurerm/r/backup_protected_file_share.html) terraform resource
* Diagnostics settings to manage logging ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-azure-diagnostic-events))

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
module "az_vm_backup" {
  source  = "claranet/run/azurerm//modules/backup"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  backup_vm_enabled         = true
  backup_postgresql_enabled = true

  vm_backup_policy_time = "23:00"

  vm_backup_monthly_retention = {
    count    = 3
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }

  logs_destinations_ids = [module.logs.id]

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2.28 |
| azurerm | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 8.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_policy_file_share.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share) | resource |
| [azurerm_backup_policy_vm.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm) | resource |
| [azurerm_data_protection_backup_policy_blob_storage.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_blob_storage) | resource |
| [azurerm_data_protection_backup_policy_disk.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_disk) | resource |
| [azurerm_data_protection_backup_policy_postgresql.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_policy_postgresql) | resource |
| [azurerm_data_protection_backup_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_vault) | resource |
| [azurerm_recovery_services_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault) | resource |
| [azurecaf_name.backup_vault](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.recovery_vault](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

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
| client\_name | Client name. | `string` | n/a | yes |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostics settings, name will be `default` if not set. | `string` | `"default"` | no |
| environment | Environment name. | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| file\_share\_backup\_daily\_policy\_retention | The number of daily file share backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| file\_share\_backup\_monthly\_retention | Map to configure the monthly File Share backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_monthly). | <pre>object({<br/>    count    = number,<br/>    weekdays = list(string),<br/>    weeks    = list(string),<br/>  })</pre> | `null` | no |
| file\_share\_backup\_policy\_custom\_name | Azure Backup - File share backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| file\_share\_backup\_policy\_frequency | Specifies the frequency for file\_share backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| file\_share\_backup\_policy\_time | The time of day to perform the file share backup in 24hour format. | `string` | `"04:00"` | no |
| file\_share\_backup\_policy\_timezone | Specifies the timezone for file share backup schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| file\_share\_backup\_weekly\_retention | Map to configure the weekly File Share backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_weekly). | <pre>object({<br/>    count    = number,<br/>    weekdays = list(string),<br/>  })</pre> | `null` | no |
| file\_share\_backup\_yearly\_retention | Map to configure the yearly File Share backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_yearly) | <pre>object({<br/>    count    = number,<br/>    weekdays = list(string),<br/>    weeks    = list(string),<br/>    months   = list(string),<br/>  })</pre> | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
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
| recovery\_vault\_alerts\_for\_all\_job\_failures\_enabled | Enabling/Disabling built-in Azure Monitor alerts for security scenarios and job failure scenarios. Defaults to true. | `bool` | `true` | no |
| recovery\_vault\_alerts\_for\_critical\_operation\_failures\_enabled | Enabling/Disabling alerts from the older (classic alerts) solution. Defaults to true. More details could be found [here](https://learn.microsoft.com/en-us/azure/backup/monitoring-and-alerts-overview). | `bool` | `true` | no |
| recovery\_vault\_cross\_region\_restore\_enabled | Is cross region restore enabled for this Vault? Can only be `true`, when `storage_mode_type` is `GeoRedundant`. | `bool` | `true` | no |
| recovery\_vault\_custom\_name | Azure Recovery Vault custom name. Empty by default, using naming convention. | `string` | `""` | no |
| recovery\_vault\_extra\_tags | Extra tags to add to Recovery Vault. | `map(string)` | `{}` | no |
| recovery\_vault\_identity\_type | Azure Recovery Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`. | `string` | `"SystemAssigned"` | no |
| recovery\_vault\_immutability | Immutability setting of the Vault, possible values are `Locked`, `Unlocked` and `Disabled`. Defaults to `Unlocked`. | `string` | `"Unlocked"` | no |
| recovery\_vault\_public\_network\_access\_enabled | Whether public network access is allowed for this Recovery Services Vault. Defaults to `true`. | `bool` | `true` | no |
| recovery\_vault\_sku | Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`. | `string` | `"Standard"` | no |
| recovery\_vault\_soft\_delete\_enabled | Is soft delete enable for this Vault? Defaults to `true`. | `bool` | `true` | no |
| recovery\_vault\_storage\_mode\_type | The storage type of the Recovery Services Vault. Possible values are `GeoRedundant`, `LocallyRedundant` and `ZoneRedundant`. Defaults to `GeoRedundant`. | `string` | `"GeoRedundant"` | no |
| resource\_group\_name | Resource group to which the resources will belong. | `string` | n/a | yes |
| stack | Stack name. | `string` | n/a | yes |
| storage\_blob\_backup\_policy\_custom\_name | Azure Backup - Storage blob backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| storage\_blob\_backup\_policy\_retention\_in\_days | The number of days to keep the Storage blob backup. | `number` | `30` | no |
| vm\_backup\_daily\_policy\_retention | The number of daily VM backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| vm\_backup\_monthly\_retention | Map to configure the monthly VM backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_monthly). | <pre>object({<br/>    count    = number,<br/>    weekdays = list(string),<br/>    weeks    = list(string),<br/>  })</pre> | `null` | no |
| vm\_backup\_policy\_custom\_name | Azure Backup - VM backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| vm\_backup\_policy\_frequency | Specifies the frequency for VM backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| vm\_backup\_policy\_time | The time of day to perform the VM backup in 24hour format. | `string` | `"04:00"` | no |
| vm\_backup\_policy\_timezone | Specifies the timezone for VM backup schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| vm\_backup\_policy\_type | Type of the Backup Policy. Possible values are `V1` and `V2` where `V2` stands for the Enhanced Policy. Defaults to `V1`. Changing this forces a new resource to be created. | `string` | `"V1"` | no |
| vm\_backup\_weekly\_retention | Map to configure the weekly VM backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_weekly). | <pre>object({<br/>    count    = number,<br/>    weekdays = list(string),<br/>  })</pre> | `null` | no |
| vm\_backup\_yearly\_retention | Map to configure the yearly VM backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_yearly). | <pre>object({<br/>    count    = number,<br/>    weekdays = list(string),<br/>    weeks    = list(string),<br/>    months   = list(string),<br/>  })</pre> | `null` | no |

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
| resource\_backup\_vault | Resource backup vault. |
| resource\_file\_share\_backup\_policy | File share Backup policy resource. |
| resource\_managed\_disk\_backup\_policy | Managed disk Backup policy resource. |
| resource\_postgresql\_backup\_policy | PostgreSQL Backup policy resource. |
| resource\_recovery\_vault | Resource recovery vault. |
| resource\_storage\_blob\_backup\_policy | Storage blob Backup policy resource. |
| resource\_vm\_backup\_policy | VM Backup policy resource. |
| storage\_blob\_backup\_policy\_id | Storage blob Backup policy ID. |
| vm\_backup\_policy\_id | VM Backup policy ID. |
| vm\_backup\_policy\_name | VM Backup policy name. |
<!-- END_TF_DOCS -->

## Related documentation

- Terraform Azure Recovery Services Vault: [terraform.io/docs/providers/azurerm/r/recovery_services_vault.html](https://www.terraform.io/docs/providers/azurerm/r/recovery_services_vault.html)
- Terraform Azure VM Backup policy: [terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html](https://www.terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html)
- Terraform Azure File Share Backup policy: [terraform.io/docs/providers/azurerm/r/backup_policy_file_share.html](https://www.terraform.io/docs/providers/azurerm/r/backup_policy_file_share.html)
- Terraform Azure Monitor Diagnostics Settings: [terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
