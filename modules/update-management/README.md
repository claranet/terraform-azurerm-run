# Azure Update Management

It includes:
* Azure Update Management using Automation Account ([documentation](https://docs.microsoft.com/en-us/azure/automation/update-management/overview))

## Version compatibility

| Module version    | Terraform version | AzureRM version |
|-------------------|-------------------|-----------------|
| >= 5.x.x          | 0.15.x, 1.0.x     | >= 2.0          |
| >= 4.x.x          | 0.13.x            | >= 2.57         |
| >= 3.x.x          | 0.12.x            | >= 2.0          |
| >= 2.x.x, < 3.x.x | 0.12.x            | <  2.0          |
| <  2.x.x          | 0.11.x            | <  2.0          |

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

module "automation_account" {
  source  = "claranet/run-iaas/azurerm//modules/automation-account"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
  client_name         = var.client_name
  stack               = var.stack
  environment         = var.environment

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]

  extra_tags = {
    foo = "bar"
  }
}

resource "time_offset" "update_template" {
  offset_hours = 4
}

locals {
  update_template_date = format("%s-%02d-%02d", time_offset.update_template.year, time_offset.update_template.month, time_offset.update_template.day + 1)
}

module "update_management" {
  source  = "claranet/run-iaas/azurerm//modules/update-management"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  automation_account_name    = module.automation_account.automation_account_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  update_management_os_list        = ["Linux"]
  update_management_scope          = [module.rg.resource_group_id]
  update_management_tags_filtering = { update_color = ["blue"] }
  update_management_schedule = [{
    startTime  = "${local.update_template_date}T02:00:00+00:00"
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
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.update](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_log_analytics_solution.update_management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_resource_group_template_deployment.update_config_standard_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.update_config_standard_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automation\_account\_name | Automation account name | `string` | n/a | yes |
| client\_name | Client name | `string` | n/a | yes |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| deploy\_update\_management\_solution | Should we deploy the Log Analytics Update solution or not | `bool` | `true` | no |
| environment | Environment name | `string` | n/a | yes |
| extra\_tags | Additional tags to add | `map(string)` | `null` | no |
| linux\_update\_management\_configuration | Linux specific update management configuration. Possible values for reboot\_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#linuxproperties) | `any` | <pre>{<br>  "excluded_packages": [],<br>  "included_packages": [],<br>  "reboot_setting": "IfRequired",<br>  "update_classifications": "Critical, Security"<br>}</pre> | no |
| linux\_update\_management\_configuration\_name | Custom configuration name for Linux Update management | `string` | `"Standard Linux Update Schedule"` | no |
| linux\_update\_management\_duration | To set the maintenance window for Linux machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H) | `string` | `null` | no |
| linux\_update\_management\_schedule | Map of specific schedule parameters for update management of Linux machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object) | `list(any)` | `null` | no |
| linux\_update\_management\_scope | Scope of the update management for Linux machines, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `null` | no |
| linux\_update\_management\_tags\_filtering | Filter scope for Linux machines using tags on VMs. Example :<pre>{ os_family = ["linux"] }</pre> | `map(any)` | `null` | no |
| linux\_update\_management\_tags\_filtering\_operator | Filter Linux VMs by `Any` or `All` specified tags. Possible values are `All` or `Any` | `string` | `null` | no |
| location | Azure location | `string` | n/a | yes |
| location\_short | Short string for Azure location | `string` | n/a | yes |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID where the logs are sent and linked to Automation account | `string` | n/a | yes |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| resource\_group\_name | Resource Group the resources will belong to | `string` | n/a | yes |
| stack | Stack name | `string` | n/a | yes |
| update\_management\_duration | To set the maintenance window, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H) | `string` | `"PT2H"` | no |
| update\_management\_os\_list | List of OS to cover. Possible values can be `Windows` or `Linux`. Define empty list to disable update management | `list(string)` | n/a | yes |
| update\_management\_schedule | Map of schedule parameters for update management. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object) | `list(any)` | n/a | yes |
| update\_management\_scope | Scope of the update management, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `null` | no |
| update\_management\_tags\_filtering | Filter scope using tags on VMs. Example :<pre>{ os_family = ["linux"] }</pre> | `map(any)` | `{}` | no |
| update\_management\_tags\_filtering\_operator | Filter VMs by `Any` or `All` specified tags. Possible values are `All` or `Any` | `string` | `"Any"` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. | `bool` | `true` | no |
| windows\_update\_management\_configuration | Windows specific update management configuration. Possible values for reboot\_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#windowsproperties) | `any` | <pre>{<br>  "excluded_kb_numbers": [],<br>  "included_kb_numbers": [],<br>  "reboot_setting": "IfRequired",<br>  "update_classifications": "Critical, Security"<br>}</pre> | no |
| windows\_update\_management\_configuration\_name | Custom configuration name for Windows Update management | `string` | `"Standard Windows Update Schedule"` | no |
| windows\_update\_management\_duration | To set the maintenance window for Windows machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H) | `string` | `null` | no |
| windows\_update\_management\_schedule | Map of specific schedule parameters for update management of Windows machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object) | `list(any)` | `null` | no |
| windows\_update\_management\_scope | Scope of the update management for Windows machines, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `null` | no |
| windows\_update\_management\_tags\_filtering | Filter scope for Windows machines using tags on VMs. Example :<pre>{ os_family = ["windows"] }</pre> | `map(any)` | `null` | no |
| windows\_update\_management\_tags\_filtering\_operator | Filter Windows VMs by `Any` or `All` specified tags. Possible values are `All` or `Any` | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Related documentation

- Microsoft Update management documentation: [docs.microsoft.com/en-us/azure/automation/update-management/overview](https://docs.microsoft.com/en-us/azure/automation/update-management/overview)
- Microsoft ARM template for Update management documentation: [docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json)
