# Azure Monitoring Function

This module deploys [FAME](https://github.com/claranet/fame) monitoring extension in an Azure Function for addition monitoring capabilities.
Built-in metrics sent:
    * `fame.azure.application_gateway.instances`: number of Application Gateway instances
    * `fame.azure.backup.file_share`: number of successful file share backups
    * `fame.azure.backup.vm`: number of successful virtual machines backups
    * `fame.azure.virtual_network_gateway.ike_event_success`: number of successful ike events for a VPN Gateway

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
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

resource "azurerm_log_analytics_workspace" "example" {
  name                = "acctest-01"
  location            = module.azure-region.location
  resource_group_name = module.rg.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "monitoring_function" {
  source  = "claranet/run-common/azurerm//modules/monitoring_function"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  splunk_token = "xxxxxx"

  log_analytics_workspace_guid = azurerm_log_analytics_workspace.example.workspace_id

  extra_tags = {
    foo = "bar"
  }
}
```

## Related documentation

Terraform Azure Log Analytics Workspace: [terraform.io/docs/providers/azurerm/r/log\_analytics\_workspace.html](https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html)

Microsoft Azure Monitor logs documentation: [docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview)

Microsoft Azure Storage Account documentation: [docs.microsoft.com/en-us/azure/storage/common/storage-account-overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview)

Microsoft Azure Blob lifecycle management documentation: [docs.microsoft.com/en-us/azure/storage/blobs/storage-lifecycle-management-concepts?tabs=azure-portal](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-lifecycle-management-concepts?tabs=azure-portal)

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.21 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| function | claranet/function-app/azurerm | 4.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_table.queries](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) | resource |
| [azurerm_storage_table_entity.queries](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table_entity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_insights\_custom\_name | FAME Application Insights custom name deployed with function app | `string` | `null` | no |
| client\_name | Client name | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| extra\_application\_settings | Extra application settings to set on monitoring function | `map(string)` | `{}` | no |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| function\_app\_custom\_name | FAME Function App custom name | `string` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_workspace\_guid | GUID of the Log Analytics Workspace on which evaluate the queries | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. All by default. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. All by default. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| metrics\_extra\_dimensions | Extra dimensions sent with metrics | `map(string)` | `{}` | no |
| name\_prefix | Name prefix for all resources generated name | `string` | `"fame"` | no |
| resource\_group\_name | Resource Group the resources will belong to | `string` | n/a | yes |
| splunk\_token | Access Token to send metrics to Splunk Observability | `string` | n/a | yes |
| stack | Stack name | `string` | n/a | yes |
| storage\_account\_name | FAME Storage Account custom name. Empty by default, using naming convention. | `string` | `null` | no |
| zip\_package\_path | Zip package path for monitoring function | `string` | `"https://github.com/claranet/fame/releases/download/v1.0.0/fame.zip"` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_service\_plan\_id | Id of the created App Service Plan |
| app\_service\_plan\_name | Name of the created App Service Plan |
| application\_insights\_app\_id | App id of the associated Application Insights |
| application\_insights\_application\_type | Application Type of the associated Application Insights |
| application\_insights\_id | Id of the associated Application Insights |
| application\_insights\_instrumentation\_key | Instrumentation key of the associated Application Insights |
| application\_insights\_name | Name of the associated Application Insights |
| function\_app\_connection\_string | Connection string of the created Function App |
| function\_app\_id | Id of the created Function App |
| function\_app\_identity | Identity block output of the Function App |
| function\_app\_name | Name of the created Function App |
| function\_app\_outbound\_ip\_addresses | Outbound IP adresses of the created Function App |
| storage\_account\_id | Id of the associated Storage Account, empty if connection string provided |
| storage\_account\_name | Name of the associated Storage Account, empty if connection string provided |
| storage\_account\_primary\_access\_key | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_primary\_connection\_string | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_access\_key | Secondary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_connection\_string | Secondary connection string of the associated Storage Account, empty if connection string provided |
| storage\_queries\_table\_name | Name of the table in the Storage Account |
<!-- END_TF_DOCS -->