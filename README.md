# Azure RUN IaaS/VM
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/run-iaas/azurerm/)

A terraform feature which includes services needed for Claranet RUN/MSP on Azure IaaS resources (VMs).

It includes:
  * Azure Backup ([example](examples/backup/modules.tf))
      * A Recovery Services Vault to store VM backups ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-overview)).
      * A VM backup policy to assign on VM instances (via the [vm-backup](https://registry.terraform.io/modules/claranet/vm-backup/) module).
      * A file share backup policy to assign on [Storage Account file shares](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction) (via the [backup_protected_file_share](https://www.terraform.io/docs/providers/azurerm/r/backup_protected_file_share.html) terraform resource)
      * A diagnostics settings to manage logging ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-azure-diagnostic-events))
  * An Automation account to execute runbooks ([documentation](https://docs.microsoft.com/fr-fr/azure/automation/automation-intro)) - Available only in module version >= 2.2.0 ([example](examples/automation-account/modules.tf))
  * Azure Update Management using Automation Account ([documentation](https://docs.microsoft.com/en-us/azure/automation/update-management/overview)) ([example](examples/update-management/modules.tf))
  * A Data Collection Rule to gather metrics and logs from Virtual Machines ([documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collection-rule-overview))

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

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

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

resource "time_offset" "update_template" {
  offset_hours = 4
}

locals {
  update_template_time = format("%02d:%02d", time_offset.update_template.hour, time_offset.update_template.minute)
  update_template_date = substr(time_offset.update_template.rfc3339, 0, 10)
}

module "run_iaas" {
  source  = "claranet/run-iaas/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  update_management_os_list        = ["Linux"]
  update_management_scope          = [module.rg.resource_group_id]
  update_management_tags_filtering = { update_color = ["blue"] }
  update_management_schedule = [{
    startTime  = "${local.update_template_date}T${local.update_template_time}:00+00:00"
    expiryTime = "9999-12-31T23:59:00+00:00"
    isEnabled  = true
    interval   = 1
    frequency  = "Month"
    timeZone   = "UTC"
    advancedSchedule = {
      monthlyOccurrences = [
        {
          occurrence = 3
          day        = "Monday"
        }
      ]
    }
  }]

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| automation\_account | ./modules/automation-account | n/a |
| backup | ./modules/backup | n/a |
| update\_management | ./modules/update-management | n/a |
| vm\_monitoring | ./modules/vm-monitoring | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automation\_account\_extra\_tags | Extra tags to add to automation account | `map(string)` | `{}` | no |
| automation\_account\_identity\_type | Automation Account identity type. Possible values include: `null`, `SystemAssigned` and `UserAssigned`. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| automation\_account\_sku | Automation account Sku | `string` | `"Basic"` | no |
| client\_name | Client name | `string` | n/a | yes |
| custom\_automation\_account\_name | Automation account custom name | `string` | `""` | no |
| data\_collection\_syslog\_facilities\_names | List of syslog to retrieve in Data Collection Rule | `list(string)` | <pre>[<br>  "auth",<br>  "authpriv",<br>  "cron",<br>  "daemon",<br>  "mark",<br>  "kern",<br>  "local0",<br>  "local1",<br>  "local2",<br>  "local3",<br>  "local4",<br>  "local5",<br>  "local6",<br>  "local7",<br>  "lpr",<br>  "mail",<br>  "news",<br>  "syslog",<br>  "user",<br>  "uucp"<br>]</pre> | no |
| data\_collection\_syslog\_levels | List of syslog levels to retrieve in Data Collection Rule | `list(string)` | <pre>[<br>  "Error",<br>  "Critical",<br>  "Alert",<br>  "Emergency"<br>]</pre> | no |
| dcr\_custom\_name | VM Monitoring - Data Collection rule custom name. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| deploy\_update\_management\_solution | Should we deploy the Log Analytics Update solution or not | `bool` | `true` | no |
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
| linux\_update\_management\_config\_name | Custom configuration name for Linux Update management | `string` | `"Standard Linux Update Schedule"` | no |
| linux\_update\_management\_configuration | Linux specific update management configuration. Possible values for reboot\_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#linuxproperties). | `any` | <pre>{<br>  "excluded_packages": [],<br>  "included_packages": [],<br>  "reboot_setting": "IfRequired",<br>  "update_classifications": "Critical, Security"<br>}</pre> | no |
| linux\_update\_management\_duration | To set the maintenance window for Linux machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H). | `string` | `null` | no |
| linux\_update\_management\_schedule | Map of specific schedule parameters for update management of Linux machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object) | `list(any)` | `null` | no |
| linux\_update\_management\_scope | Scope of the update management for Linux machines, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `null` | no |
| linux\_update\_management\_tags\_filtering | Filter scope for Linux machines using tags on VMs. Example :<pre>{ os_family = ["linux"] }</pre> | `map(any)` | `null` | no |
| linux\_update\_management\_tags\_filtering\_operator | Filter Linux VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`. | `string` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_resource\_group\_name | Log Analytics Workspace resource group name (if different from `resource_group_name` variable.) | `string` | `null` | no |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID where the logs are sent and linked to Automation account | `string` | n/a | yes |
| log\_analytics\_workspace\_link\_enabled | Enable Log Analytics Workspace that will be connected with the automation account | `bool` | `true` | no |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| recovery\_vault\_cross\_region\_restore\_enabled | Is cross region restore enabled for this Vault? Only can be `true`, when `storage_mode_type` is `GeoRedundant`. Defaults to `false`. | `bool` | `false` | no |
| recovery\_vault\_custom\_name | Azure Recovery Vault custom name. Empty by default, using naming convention. | `string` | `""` | no |
| recovery\_vault\_extra\_tags | Extra tags to add to recovery vault | `map(string)` | `{}` | no |
| recovery\_vault\_identity\_type | Azure Recovery Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`. | `string` | `"SystemAssigned"` | no |
| recovery\_vault\_sku | Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`. | `string` | `"Standard"` | no |
| recovery\_vault\_soft\_delete\_enabled | Is soft delete enable for this Vault? Defaults to `true`. | `bool` | `true` | no |
| recovery\_vault\_storage\_mode\_type | The storage type of the Recovery Services Vault. Possible values are `GeoRedundant`, `LocallyRedundant` and `ZoneRedundant`. Defaults to `GeoRedundant`. | `string` | `"GeoRedundant"` | no |
| resource\_group\_name | Resource Group the resources will belong to | `string` | n/a | yes |
| stack | Stack name | `string` | n/a | yes |
| update\_management\_duration | To set the maintenance window, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H). | `string` | `"PT2H"` | no |
| update\_management\_name\_prefix | Name prefix to apply on Update Management resources | `string` | `null` | no |
| update\_management\_os\_list | List of OS to cover. Possible values can be `Windows` or `Linux`. Define empty list to disable update management. | `list(string)` | n/a | yes |
| update\_management\_schedule | List of Map with schedule parameters for update management. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object) | `list(any)` | n/a | yes |
| update\_management\_scope | Scope of the update management, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `null` | no |
| update\_management\_tags\_filtering | Filter scope using tags on VMs. Example :<pre>{ os_family = ["linux"] }</pre> | `map(any)` | `{}` | no |
| update\_management\_tags\_filtering\_operator | Filter VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`. | `string` | `"Any"` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_automation_account_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| vm\_backup\_daily\_policy\_retention | The number of daily VM backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| vm\_backup\_monthly | Map to configure the monthly backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_monthly | `any` | `{}` | no |
| vm\_backup\_policy\_custom\_name | Azure Backup - VM backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| vm\_backup\_policy\_frequency | Specifies the frequency for VM backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| vm\_backup\_policy\_time | The time of day to preform the backup in 24hour format. | `string` | `"04:00"` | no |
| vm\_backup\_policy\_timezone | Specifies the timezone for schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| vm\_backup\_weekly | Map to configure the weekly backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_weekly | `any` | `{}` | no |
| vm\_backup\_yearly | Map to configure the yearly backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_yearly | `any` | `{}` | no |
| windows\_update\_management\_configuration | Windows specific update management configuration. Possible values for reboot\_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#windowsproperties). | `any` | <pre>{<br>  "excluded_kb_numbers": [],<br>  "included_kb_numbers": [],<br>  "reboot_setting": "IfRequired",<br>  "update_classifications": "Critical, Security"<br>}</pre> | no |
| windows\_update\_management\_configuration\_name | Custom configuration name for Windows Update management | `string` | `"Standard Windows Update Schedule"` | no |
| windows\_update\_management\_duration | To set the maintenance window for Windows machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H). | `string` | `null` | no |
| windows\_update\_management\_schedule | Map of specific schedule parameters for update management of Windows machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object) | `list(any)` | `null` | no |
| windows\_update\_management\_scope | Scope of the update management for Windows machines, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `null` | no |
| windows\_update\_management\_tags\_filtering | Filter scope for Windows machines using tags on VMs. Example :<pre>{ os_family = ["windows"] }</pre> | `map(any)` | `null` | no |
| windows\_update\_management\_tags\_filtering\_operator | Filter Windows VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| automation\_account\_dsc\_primary\_access\_key | Azure Automation Account DSC Primary Acess Key |
| automation\_account\_dsc\_secondary\_access\_key | Azure Automation Account DSC Secondary Acess Key |
| automation\_account\_dsc\_server\_endpoint | Azure Automation Account DSC Server Endpoint |
| automation\_account\_id | Azure Automation Account ID |
| automation\_account\_name | Azure Automation Account name |
| data\_collection\_rule | Azure Monitor Data Collection Rule object |
| data\_collection\_rule\_id | Id of the Azure Monitor Data Collection Rule |
| data\_collection\_rule\_name | Name of the Azure Monitor Data Collection Rule |
| file\_share\_backup\_policy\_id | File share Backup policy ID |
| file\_share\_backup\_policy\_name | File share Backup policy name |
| recovery\_vault\_id | Azure Recovery Services Vault ID |
| recovery\_vault\_name | Azure Recovery Services Vault name |
| vm\_backup\_policy\_id | VM Backup policy ID |
| vm\_backup\_policy\_name | VM Backup policy name |
<!-- END_TF_DOCS -->

## Related documentation

- Microsoft Update management documentation: [docs.microsoft.com/en-us/azure/automation/update-management/overview](https://docs.microsoft.com/en-us/azure/automation/update-management/overview)
- Microsoft ARM template for Update management documentation: [docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json)