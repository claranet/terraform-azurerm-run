# Azure Automation Account

This module creates an [Automation Account](https://learn.microsoft.com/en-us/azure/automation/overview) that may be
linked a Log Analytics Workspace for legacy Update Management solution.

Please note that the associated `RunAs Account` is not created.

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
module "automation_account" {
  source  = "claranet/run/azurerm//modules/automation-account"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name
  client_name         = var.client_name
  stack               = var.stack
  environment         = var.environment

  log_analytics_workspace_id = module.logs.id
  logs_destinations_ids      = [module.logs.id]

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 8.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_log_analytics_linked_service.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service) | resource |
| [azurecaf_name.automation_account](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automation\_account\_extra\_tags | Extra tags to add to automation account | `map(string)` | `{}` | no |
| automation\_account\_identity\_type | Automation Account identity type. Possible values include: `null`, `SystemAssigned` and `UserAssigned`. | <pre>object({<br/>    type         = string<br/>    identity_ids = list(string)<br/>  })</pre> | <pre>{<br/>  "identity_ids": [],<br/>  "type": "SystemAssigned"<br/>}</pre> | no |
| automation\_account\_sku | Automation account Sku | `string` | `"Basic"` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_name | Automation account custom name. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostics settings, name will be `default` if not set. | `string` | `"default"` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_resource\_group\_name | Log Analytics Workspace resource group name (if different from `resource_group_name` variable.) | `string` | `null` | no |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID that will be connected with the automation account | `string` | `""` | no |
| log\_analytics\_workspace\_link\_enabled | Enable Log Analytics Workspace that will be connected with the automation account | `bool` | `true` | no |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dsc\_primary\_access\_key | Azure Automation Account DSC primary access key. |
| dsc\_secondary\_access\_key | Azure Automation Account DSC secondary access key. |
| dsc\_server\_endpoint | Azure Automation Account DSC server endpoint. |
| id | Azure Automation Account ID. |
| identity | Identity block with principal ID and tenant ID. |
| module\_diagnostics | Diagnostic settings module output. |
| name | Azure Automation Account name. |
| resource | Automation account resource object. |
| resource\_log\_analytics\_linked\_service | Log Analytics linked service resource object. |
<!-- END_TF_DOCS -->
