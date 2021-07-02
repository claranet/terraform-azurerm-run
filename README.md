# Azure RUN IaaS/VM
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/run-iaas/azurerm/)

A terraform feature which includes services needed for Claranet RUN/MSP on Azure IaaS resources (VMs).

It includes:
  * Azure Backup
      * A Recovery Services Vault to store VM backups ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-overview)).
      * A VM backup policy to assign on VM instances (via the [vm-backup](https://registry.terraform.io/modules/claranet/vm-backup/) module).
      * A file share backup policy to assign on [Storage Account file shares](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction) (via the [backup_protected_file_share](https://www.terraform.io/docs/providers/azurerm/r/backup_protected_file_share.html) terraform resource)
      * A diagnostics settings to manage logging ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-azure-diagnostic-events))
  * An Automation account to execute runbooks ([documentation](https://docs.microsoft.com/fr-fr/azure/automation/automation-intro)) - Available only in module version >= 2.2.0
  * Azure Patch Management using Automation Account for Linux only actually ([documentation](https://docs.microsoft.com/en-us/azure/automation/update-management/overview))
  Available only in module version >= 4.2.0

## Version compatibility

| Module version | Terraform version | AzureRM version |
<<<<<<< HEAD
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.57         |
=======
|----------------|-------------------| --------------- |
| >= 5.x.x       | 0.15.x, 1.0.x     | >= 2.0          |
>>>>>>> 93a7673 (AZ-55: Move patch-management to a submodule)
| >= 4.x.x       | 0.13.x            | >= 2.57         |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

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
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name          = module.rg.resource_group_name
  log_analytics_workspace_name = module.logs.log_analytics_workspace_name

  patch_mgmt_scope = [module.rg.resource_groupe_id]
  patch_mgmt_schedule = [{
    startTime  = "${local.update_template_date}T${local.update_template_time}:00+00:00"
    expirytime = "9999-12-31T23:59:00+00:00"
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

  extra_tags = {
    foo    = "bar"
  }
}
```

## Using sub-modules
The integrated services can be used separately with the same inputs and outputs when it's a sub module.

### Azure Backup
```hcl
module "az-backup" {
  source  = "claranet/run-iaas/azurerm//modules/backup"
  version = "x.x.x"

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  extra_tags = {
    foo    = "bar"
  }
}
```

### Azure Automation Account
```hcl
module "automation-account" {
  source  = "claranet/run-iaas/azurerm//modules/automation-account"
  version = "x.x.x"

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  log_analytics_workspace_name = module.logs.log_analytics_workspace_name

  extra_tags = {
    foo    = "bar"
  }
}
```

### Azure Patch Management
```hcl
resource "time_offset" "update_template" {
  offset_hours = 4
}

locals {
  update_template_time = format("%02d:%02d", time_offset.update_template.hour, time_offset.update_template.minute)
  update_template_date = substr(time_offset.update_template.rfc3339, 0, 10)
}

module "patch-management" {
  source  = "claranet/run-iaas/azurerm//modules/patch-management"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name          = module.rg.resource_group_name

  automation_account_name    = module.automation-account.automation_account_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  
  patch_mgmt_scope = [module.rg.resource_groupe_id]
  patch_mgmt_schedule = [{
    startTime  = "${local.update_template_date}T${local.update_template_time}:00+00:00"
    expirytime = "9999-12-31T23:59:00+00:00"
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
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| automation\_account | ./modules/automation-account | n/a |
| backup | ./modules/backup | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automation\_account\_extra\_tags | Extra tags to add to automation account | `map(string)` | `{}` | no |
| automation\_account\_sku | Automation account Sku | `string` | `"Basic"` | no |
| client\_name | Client name | `string` | n/a | yes |
| custom\_automation\_account\_name | Automation account custom name | `string` | `""` | no |
| enable\_patch\_management | Boolean to enable patch management. Actually, only Linux VMs are supported. | `bool` | `true` | no |
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
| log\_analytics\_resource\_group\_name | Log Analytics Workspace resource group name (if different from `resource_group_name` variable.) | `string` | `""` | no |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID where the logs are sent and linked to Automation account | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| name\_prefix | Name prefix for all resources generated name | `string` | `""` | no |
| patch\_mgmt\_linux\_duration | To set the maintenance window, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H). | `string` | `"PT2H"` | no |
| patch\_mgmt\_linux\_reboot\_setting | Used to define the reboot setting you want. Possible values are `IfRequired`, `RebootOnly`, `Never`, `Always`. | `string` | `"Never"` | no |
| patch\_mgmt\_linux\_schedule | Map of schedule parameters for patch management. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object) | `list(any)` | `[]` | no |
| patch\_mgmt\_linux\_scope | Scope of the patch management, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `[]` | no |
| patch\_mgmt\_linux\_tags\_filtering | Filter scope using tags on VMs. Example :<pre>{ os_family = ["linux"] }</pre> | `map(any)` | `{}` | no |
| patch\_mgmt\_linux\_tags\_filtering\_operator | Filter VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`. | `string` | `"Any"` | no |
| patch\_mgmt\_linux\_update\_classifications | Patch Management update classifications. This variable is used to define what kind of updates do you want to apply. Possible values are `Critical`, `Security` and `Other` | `list(string)` | <pre>[<br>  "Critical",<br>  "Security"<br>]</pre> | no |
| patch\_mgmt\_os | List of OS to cover. Possible values can be `Windows` or `Linux`. | `list(string)` | `[]` | no |
| patch\_mgmt\_windows\_duration | To set the maintenance window, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H). | `string` | `"PT2H"` | no |
| patch\_mgmt\_windows\_reboot\_setting | Used to define the reboot setting you want. Possible values are `IfRequired`, `RebootOnly`, `Never`, `Always`. | `string` | `"Never"` | no |
| patch\_mgmt\_windows\_schedule | Map of schedule parameters for patch management. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object) | `list(any)` | `[]` | no |
| patch\_mgmt\_windows\_scope | Scope of the patch management, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `[]` | no |
| patch\_mgmt\_windows\_tags\_filtering | Filter scope using tags on VMs. Example :<pre>{ os_family = ["linux"] }</pre> | `map(any)` | `{}` | no |
| patch\_mgmt\_windows\_tags\_filtering\_operator | Filter VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`. | `string` | `"Any"` | no |
| patch\_mgmt\_windows\_update\_classifications | Patch Management update classifications. This variable is used to define what kind of updates do you want to apply. Possible values are `Critical`, `Security` and `Other` | `list(string)` | <pre>[<br>  "Critical",<br>  "Security"<br>]</pre> | no |
| recovery\_vault\_custom\_name | Azure Recovery Vault custom name. Empty by default, using naming convention. | `string` | `""` | no |
| recovery\_vault\_extra\_tags | Extra tags to add to recovery vault | `map(string)` | `{}` | no |
| recovery\_vault\_identity\_type | Azure Recovery Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`. | `string` | `"SystemAssigned"` | no |
| recovery\_vault\_sku | Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`. | `string` | `"Standard"` | no |
| resource\_group\_name | Resource Group the resources will belong to | `string` | n/a | yes |
| stack | Stack name | `string` | n/a | yes |
| vm\_backup\_daily\_policy\_retention | The number of daily VM backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| vm\_backup\_monthly | Map to configure the monthly backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_monthly | `any` | `{}` | no |
| vm\_backup\_policy\_custom\_name | Azure Backup - VM backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| vm\_backup\_policy\_frequency | Specifies the frequency for VM backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| vm\_backup\_policy\_time | The time of day to preform the backup in 24hour format. | `string` | `"04:00"` | no |
| vm\_backup\_policy\_timezone | Specifies the timezone for schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| vm\_backup\_weekly | Map to configure the weekly backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_weekly | `any` | `{}` | no |
| vm\_backup\_yearly | Map to configure the yearly backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_yearly | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| automation\_account\_dsc\_primary\_access\_key | Azure Automation Account DSC Primary Acess Key |
| automation\_account\_dsc\_secondary\_access\_key | Azure Automation Account DSC Secondary Acess Key |
| automation\_account\_dsc\_server\_endpoint | Azure Automation Account DSC Server Endpoint |
| automation\_account\_id | Azure Automation Account ID |
| automation\_account\_name | Azure Automation Account name |
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
- Terraform Azure Automation Account: [terraform.io/docs/providers/azurerm/r/automation_account.html](https://www.terraform.io/docs/providers/azurerm/r/automation_account.html)
- Terraform Azure Monitor Diagnostics Settings: [terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
