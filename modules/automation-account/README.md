# Azure Automation Account

This module creates an automation acccount.
It can be linked to a Log Analytics Workspace (mandatory is you aim to use the Patch Management solution too).
Please note that the associated RunAs Account is not created.

## Version compatibility

| Module version    | Terraform version | AzureRM version |
| ----------------- | ----------------- | --------------- |
| >= 5.x.x          | 0.15.x & 1.0.x    | >= 2.57         |
| >= 4.x.x          | 0.13.x            | >= 2.57         |
| >= 3.x.x          | 0.12.x            | >= 2.0          |
| >= 2.x.x, < 3.x.x | 0.12.x            | <  2.0          |
| <  2.x.x          | 0.11.x            | <  2.0          |

## Usage

Terraform module declaration example for your dashboard stack with all required modules:

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "2.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "2.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "automation-account" {
  source  = "claranet/run-iaas/azurerm//modules/automation-account"
  version = "x.x.x"

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name          = module.rg.resource_group_name
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
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 6.4.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.automation_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_log_analytics_linked_service.link_workspace_automation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service) | resource |
| [azurecaf_name.automation_account](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automation\_account\_extra\_tags | Extra tags to add to automation account | `map(string)` | `{}` | no |
| automation\_account\_identity\_type | Automation Account identity type. Possible values include: `null`, `SystemAssigned` and `UserAssigned`. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| automation\_account\_sku | Automation account Sku | `string` | `"Basic"` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_automation\_account\_name | Automation account custom name | `string` | `""` | no |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_resource\_group\_name | Log Analytics Workspace resource group name (if different from `resource_group_name` variable.) | `string` | `null` | no |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID that will be connected with the automation account | `string` | `""` | no |
| log\_analytics\_workspace\_link\_enabled | Enable Log Analytics Workspace that will be connected with the automation account | `bool` | `true` | no |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_automation_account_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| automation\_account\_dsc\_primary\_access\_key | Azure Automation Account DSC primary access key |
| automation\_account\_dsc\_secondary\_access\_key | Azure Automation Account DSC secondary access key |
| automation\_account\_dsc\_server\_endpoint | Azure Automation Account DSC server endpoint |
| automation\_account\_id | Azure Automation Account ID |
| automation\_account\_identity | Identity block with principal ID and tenant ID |
| automation\_account\_name | Azure Automation Account name |
<!-- END_TF_DOCS -->
