# Azure Automation Account

This module creates an automation acccount.
It can be linked to a Log Analytics Workspace (mandatory is you aim to use the Patch Management solution too).
Please note that the associated RunAs Account is not created.

## Version compatibility

| Module version    | Terraform version | AzureRM version |
|-------------------|-------------------|-----------------|
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automation\_account\_extra\_tags | Extra tags to add to automation account | `map(string)` | `{}` | no |
| automation\_account\_sku | Automation account Sku | `string` | `"Basic"` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_automation\_account\_name | Automation account custom name | `string` | `""` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| law\_resource\_group\_name | Resource group of Log Analytics Workspace that will be connected with the automation account (default is the same RG that the one hosting the automation account) | `string` | `""` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID that will be connected with the automation account | `string` | `""` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| automation\_account\_dsc\_primary\_access\_key | Azure Automation Account DSC Primary Acess Key |
| automation\_account\_dsc\_secondary\_access\_key | Azure Automation Account DSC Secondary Acess Key |
| automation\_account\_dsc\_server\_endpoint | Azure Automation Account DSC Server Endpoint |
| automation\_account\_id | Azure Automation Account ID |
| automation\_account\_name | Azure Automation Account name |
