# Azure Monitoring Function

This module deploys [FAME](https://github.com/claranet/fame) monitoring extension in an Azure Function for addition monitoring capabilities.
Built-in metrics sent:

  * `fame.azure.application_gateway.instances`: number of Application Gateway instances
  * `fame.azure.backup.file_share`: number of successful file share backups
  * `fame.azure.backup.vm`: number of successful virtual machines backups
  * `fame.azure.virtual_network_gateway.ike_event_success`: number of successful ike events for a VPN Gateway
  * `fame.azure.virtual_network_gateway.total_flow_count`: number of packets transiting through the VPN Gateway
  * `fame.azure.virtual_network_gateway.tunnel_status`: IPSEC Tunnels status on VPN Gateway
  * `fame.azure.update_center.updates_status`: number of updates performed with Update Center along with their statuses
  * `fame.azure.update_center.missing_updates`: number of updates missing on Virtual Machines managed by Update Center
  * `fame.azure.automation_update.updates_status`: number of updates performed with legacy Update Management along with their statuses
  * `fame.azure.automation_update.missing_updates`: number of updates missing on Virtual Machines managed by legacy Update Management

Note:

The Storage Account associated to the FAME Function app has now network rules created and enabled by default to follow hardening guidelines.
You might need to authorize IPs or change the network rules parameters by using `storage_account_network_rules_enabled` or `storage_account_authorized_ips`.

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
module "monitoring" {
  source  = "claranet/run/azurerm//modules/monitoring-function"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  log_analytics_workspace_guid = module.logs.log_analytics_workspace_guid

  application_insights_log_analytics_workspace_id = module.logs.id

  splunk_token = "xxxxxx"

  logs_destinations_ids = [module.logs.id]

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| function | claranet/function-app/azurerm | ~> 8.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_table.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) | resource |
| [azurerm_storage_table_entity.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table_entity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_insights\_custom\_name | FAME Application Insights custom name deployed with function app | `string` | `null` | no |
| application\_insights\_enabled | Whether Application Insights should be deployed. | `bool` | `true` | no |
| application\_insights\_log\_analytics\_workspace\_id | ID of the Log Analytics Workspace to be used with Application Insights. | `string` | n/a | yes |
| client\_name | Client name. | `string` | n/a | yes |
| datadog\_api\_key | API Key to send metrics to Datadog. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostics settings, name will be `default` if not set. | `string` | `"default"` | no |
| environment | Environment name. | `string` | n/a | yes |
| extra\_application\_settings | Extra application settings to set on monitoring function. | `map(string)` | `{}` | no |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| function\_app\_custom\_name | FAME Function App custom name | `string` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_workspace\_guid | GUID of the Log Analytics Workspace on which evaluate the queries. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| metrics\_extra\_dimensions | Extra dimensions sent with metrics. | `map(string)` | `{}` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `"fame"` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| rbac\_storage\_contributor\_role\_principal\_ids | The principal IDs of the users, groups, and service principals to assign the `Storage Account Contributor` role to. | `list(string)` | `[]` | no |
| rbac\_storage\_table\_role\_principal\_ids | The principal IDs of the users, groups, and service principals to assign the `Storage Table Data *` role to. | <pre>object({<br/>    contributors = optional(list(string), [])<br/>    readers      = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| resource\_group\_name | Resource group to which the resources will belong. | `string` | n/a | yes |
| service\_plan\_custom\_name | FAME Service Plan custom name | `string` | `null` | no |
| splunk\_token | Access Token to send metrics to Splunk Observability. | `string` | `null` | no |
| stack | Stack name. | `string` | n/a | yes |
| storage\_account\_advanced\_threat\_protection\_enabled | FAME advanded thread protection (aka ATP) on Function App's storage account. | `bool` | `false` | no |
| storage\_account\_custom\_name | FAME Storage Account custom name. Empty by default, using naming convention. | `string` | `null` | no |
| zip\_package\_path | Zip package path for monitoring function. | `string` | `"https://github.com/claranet/fame/releases/download/v2.0.0/fame.zip"` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_insights\_app\_id | App ID of the associated Application Insights. |
| application\_insights\_application\_type | Application Type of the associated Application Insights. |
| application\_insights\_id | ID of the associated Application Insights. |
| application\_insights\_instrumentation\_key | Instrumentation key of the associated Application Insights. |
| application\_insights\_name | Name of the associated Application Insights. |
| function\_app\_connection\_string | Connection string of the created Function App. |
| function\_app\_id | ID of the created Function App. |
| function\_app\_identity\_principal\_id | Identity principal ID output of the Function App. |
| function\_app\_name | Name of the created Function App. |
| function\_app\_outbound\_ip\_addresses | Outbound IP addresses of the created Function App. |
| module\_function | Module function outputs. |
| resource | Storage table resource object. |
| resource\_query | Storage table query resource object. |
| service\_plan\_id | ID of the created Service Plan. |
| service\_plan\_name | Name of the created Service Plan. |
| storage\_account\_id | ID of the associated Storage Account, empty if connection string provided. |
| storage\_account\_name | Name of the associated Storage Account, empty if connection string provided. |
| storage\_account\_primary\_access\_key | Primary connection string of the associated Storage Account, empty if connection string provided. |
| storage\_account\_primary\_connection\_string | Primary connection string of the associated Storage Account, empty if connection string provided. |
| storage\_account\_secondary\_access\_key | Secondary connection string of the associated Storage Account, empty if connection string provided. |
| storage\_account\_secondary\_connection\_string | Secondary connection string of the associated Storage Account, empty if connection string provided. |
| storage\_queries\_table\_name | Name of the queries table in the Storage Account. |
<!-- END_TF_DOCS -->
