# Azure Patch Management

It includes:
* Azure Patch Management using Automation Account for Linux only actually ([documentation](https://docs.microsoft.com/en-us/azure/automation/update-management/overview))
  Available only in module version >= 4.2.0
    

## Version compatibility

| Module version    | Terraform version | AzureRM version |
|-------------------|-------------------|-----------------|
| >= 5.x.x          | 0.15.x, 1.0.x     | >= 2.0          |
| >= 4.x.x          | 0.13.x            | >= 2.43         |
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

  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  patch_mgmt_linux_scope = [module.rg.resource_groupe_id]
  patch_mgmt_linux_schedule = [{
    startTime  = "${local.update_template_date}T${local.update_template_time}:00+00:00"
    expirytime = "9999-12-31T23:59:00+00:00"
    isEnabled  = true
    interval   = 1
    frequency  = "Month"
    timeZone   = "Europe/Paris"
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automation\_account\_name | Automation account name | `string` | n/a | yes |
| client\_name | Client name | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID where the logs are sent and linked to Automation account | `string` | n/a | yes |
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
| resource\_group\_name | Resource Group the resources will belong to | `string` | n/a | yes |
| stack | Stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| patch\_mgmt\_linux\_template\_deployment\_id | ID of the template deployment for Linux Patch Management |
| patch\_mgmt\_windows\_template\_deployment\_id | ID of the template deployment for Windows Patch Management |

## Related documentation

- Terraform Azure Log Analytics Solution: [registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution)
- Microsoft Patch management documentation: [docs.microsoft.com/en-us/azure/automation/update-management/overview](https://docs.microsoft.com/en-us/azure/automation/update-management/overview)
- Microsoft ARM template for Patch management documentation: [docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json)
