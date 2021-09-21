# Azure RUN Common feature
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/run-common/azurerm/)

A Terraform modules composition (feature) which includes services needed for Claranet RUN/MSP.

It includes:
* Log Management with following resources
  * Log Analytics Workspace
  * Storage Account with SAS Token to upload logs to
* Key Vault
* [FAME](https://github.com/claranet/fame) monitoring function for additional metrics. Built-in metrics sent:
  * `fame.azure.application_gateway.instances`: number of Application Gateway instances
  * `fame.azure.backup.file_share`: number of successful file share backups
  * `fame.azure.backup.vm`: number of successful virtual machines backups
  * `fame.azure.virtual_network_gateway.ike_event_success`: number of successful ike events for a VPN Gateway

## Requirements

* [PowerShell with Az module](https://docs.microsoft.com/en-us/powershell/azure/install-Az-ps?view=azps-3.6.1) >= 3.6 is mandatory and is used to configure IIS logs collect in Azure Monitor

## Using sub-modules

The integrated services can be used separately with the same inputs and outputs when it's a sub module.

### Log management

See `logs` sub-module [README](./modules/logs/README.md).

### Monitoring function

See `monitoring_function` [README](./modules/monitoring\_function/README.md)

### Key Vault

See Key Vault module: [terraform-azurerm-keyvault](https://github.com/claranet/terraform-azurerm-keyvault).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

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

module "global_run" {
  source  = "claranet/run-common/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  tenant_id                        = var.azure_tenant_id
  monitoring_function_splunk_token = "xxxxxx"

  extra_tags = {
    foo = "bar"
  }
}

```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.48 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| keyvault | claranet/keyvault/azurerm | 4.4.0 |
| logs | ./modules/logs | n/a |
| monitoring\_function | ./modules/monitoring_function | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.function_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| keyvault\_admin\_objects\_ids | Ids of the objects that can do all operations on all keys, secrets and certificates | `list(string)` | `[]` | no |
| keyvault\_custom\_name | Name of the Key Vault, generated if not set. | `string` | `""` | no |
| keyvault\_enabled\_for\_deployment | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| keyvault\_enabled\_for\_disk\_encryption | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| keyvault\_enabled\_for\_template\_deployment | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| keyvault\_extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| keyvault\_logs\_categories | Log categories to send to destinations. All by default. | `list(string)` | `null` | no |
| keyvault\_logs\_metrics\_categories | Metrics categories to send to destinations. All by default. | `list(string)` | `null` | no |
| keyvault\_network\_acls | Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more informations. | <pre>object({<br>    bypass                     = string,<br>    default_action             = string,<br>    ip_rules                   = list(string),<br>    virtual_network_subnet_ids = list(string)<br>  })</pre> | `null` | no |
| keyvault\_reader\_objects\_ids | Ids of the objects that can read all keys, secrets and certificates | `list(string)` | `[]` | no |
| keyvault\_resource\_group\_name | Resource Group the Key Vault will belong to. Will use `resource_group_name` if not set. | `string` | `""` | no |
| keyvault\_sku | The Name of the SKU used for this Key Vault. Possible values are "standard" and "premium". | `string` | `"standard"` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_workspace\_custom\_name | Azure Log Analytics Workspace custom name. Empty by default, using naming convention. | `string` | `""` | no |
| log\_analytics\_workspace\_enable\_iis\_logs | Specifies if IIS logs should be collected for linked Virtual Machines | `bool` | `false` | no |
| log\_analytics\_workspace\_extra\_tags | Extra tags to add to the Log Analytics Workspace | `map(string)` | `{}` | no |
| log\_analytics\_workspace\_name\_prefix | Log Analytics name prefix | `string` | `""` | no |
| log\_analytics\_workspace\_retention\_in\_days | The workspace data retention in days. Possible values range between 30 and 730. | `number` | `30` | no |
| log\_analytics\_workspace\_sku | Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03). | `string` | `"PerGB2018"` | no |
| logs\_delete\_after\_days\_since\_modification\_greater\_than | Delete blob after x days without modification | `number` | `365` | no |
| logs\_resource\_group\_name | Resource Group the resources for log management will belong to. Will use `resource_group_name` if not set. | `string` | `""` | no |
| logs\_storage\_account\_appservices\_container\_name | Name of the container in which App Services logs are stored | `string` | `"app-services"` | no |
| logs\_storage\_account\_archived\_logs\_fileshare\_name | Name of the file share in which externalized logs are stored | `string` | `"archived-logs"` | no |
| logs\_storage\_account\_archived\_logs\_fileshare\_quota | The maximum size in GB of the archived-logs file share, default is 5120 | `number` | `null` | no |
| logs\_storage\_account\_custom\_name | Storage Account for logs custom name. Empty by default, using naming convention. | `string` | `""` | no |
| logs\_storage\_account\_enable\_advanced\_threat\_protection | Enable/disable Advanced Threat Protection, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information. | `bool` | `false` | no |
| logs\_storage\_account\_enable\_appservices\_container | Boolean flag which controls if App Services logs container should be created. | `bool` | `false` | no |
| logs\_storage\_account\_enable\_archived\_logs\_fileshare | Enable/disable archived-logs file share creation | `bool` | `false` | no |
| logs\_storage\_account\_enable\_archiving | Enable/disable blob archiving lifecycle | `bool` | `true` | no |
| logs\_storage\_account\_enable\_https\_traffic\_only | Enable/disable HTTPS traffic only | `bool` | `true` | no |
| logs\_storage\_account\_extra\_tags | Extra tags to add to Storage Account | `map(string)` | `{}` | no |
| logs\_storage\_account\_kind | Storage Account Kind | `string` | `"StorageV2"` | no |
| logs\_storage\_account\_name\_prefix | Storage Account name prefix | `string` | `""` | no |
| logs\_storage\_account\_sas\_expiry | Storage Account SAS Token end date (expiry). Specifies the UTC datetime (Y-m-d'T'H:M'Z') at which the SAS becomes invalid. | `string` | `"2042-01-01T00:00:00Z"` | no |
| logs\_storage\_min\_tls\_version | Storage Account minimal TLS version | `string` | `"TLS1_2"` | no |
| logs\_tier\_to\_archive\_after\_days\_since\_modification\_greater\_than | Change blob tier to Archive after x days without modification | `number` | `90` | no |
| logs\_tier\_to\_cool\_after\_days\_since\_modification\_greater\_than | Change blob tier to cool after x days without modification | `number` | `30` | no |
| monitoring\_function\_application\_insights\_custom\_name | FAME Application Insights custom name. Empty by default, using naming convention. | `string` | `null` | no |
| monitoring\_function\_assign\_role\_on\_workspace | True to assign role for the monitoring Function on the Log Analytics Workspace | `bool` | `true` | no |
| monitoring\_function\_enabled | Enable/disable monitoring function | `bool` | `true` | no |
| monitoring\_function\_extra\_application\_settings | Extra application settings to set on monitoring Function | `map(string)` | `{}` | no |
| monitoring\_function\_extra\_tags | Monitoring function extra tags to add | `map(string)` | `{}` | no |
| monitoring\_function\_function\_app\_custom\_name | FAME Function App custom name. Empty by default, using naming convention. | `string` | `null` | no |
| monitoring\_function\_logs\_categories | Monitoring function log categories to send to destinations. All by default. | `list(string)` | `null` | no |
| monitoring\_function\_logs\_metrics\_categories | Monitoring function metrics categories to send to destinations. All by default. | `list(string)` | `null` | no |
| monitoring\_function\_metrics\_extra\_dimensions | Extra dimensions sent with metrics | `map(string)` | `{}` | no |
| monitoring\_function\_splunk\_token | Access Token to send metrics to Splunk Observability | `string` | n/a | yes |
| monitoring\_function\_storage\_account\_custom\_name | FAME Storage Account custom name. Empty by default, using naming convention. | `string` | `null` | no |
| monitoring\_function\_zip\_package\_path | Zip package path for monitoring function | `string` | `"https://github.com/claranet/fame/releases/download/v1.0.0/fame.zip"` | no |
| name\_prefix | Name prefix for all resources generated name | `string` | `""` | no |
| resource\_group\_name | Resource Group the resources will belong to | `string` | n/a | yes |
| stack | Stack name | `string` | n/a | yes |
| tenant\_id | Tenant ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| keyvault\_id | Id of the Key Vault |
| keyvault\_name | Name of the Key Vault |
| keyvault\_resource\_group\_name | Resource Group the Key Vault belongs to |
| keyvault\_uri | URI of the Key Vault |
| log\_analytics\_workspace\_guid | The Log Analytics Workspace GUID. |
| log\_analytics\_workspace\_id | The Log Analytics Workspace ID. |
| log\_analytics\_workspace\_name | The Log Analytics Workspace name. |
| log\_analytics\_workspace\_portal\_url | The Portal URL for the Log Analytics Workspace. |
| log\_analytics\_workspace\_primary\_key | The Primary shared key for the Log Analytics Workspace. |
| log\_analytics\_workspace\_secondary\_key | The Secondary shared key for the Log Analytics Workspace. |
| logs\_resource\_group\_name | Resource Group the logs resources belongs to |
| logs\_storage\_account\_appservices\_container\_name | Name of the container in which App Services logs are stored |
| logs\_storage\_account\_archived\_logs\_fileshare\_name | Name of the file share in which externalized logs are stored |
| logs\_storage\_account\_id | Id of the dedicated Storage Account |
| logs\_storage\_account\_name | Name of the logs Storage Account |
| logs\_storage\_account\_primary\_access\_key | Primary connection string of the logs Storage Account, empty if connection string provided |
| logs\_storage\_account\_primary\_connection\_string | Primary connection string of the logs Storage Account, empty if connection string provided |
| logs\_storage\_account\_sas\_token | SAS Token generated for logs access on Storage Account with full permissions on containers and objects for blob and table services. |
| logs\_storage\_account\_secondary\_access\_key | Secondary connection string of the logs Storage Account, empty if connection string provided |
| logs\_storage\_account\_secondary\_connection\_string | Secondary connection string of the logs Storage Account, empty if connection string provided |
| monitoring\_function\_app\_service\_plan\_id | Id of the created App Service Plan |
| monitoring\_function\_app\_service\_plan\_name | Name of the created App Service Plan |
| monitoring\_function\_application\_insights\_app\_id | App id of the associated Application Insights |
| monitoring\_function\_application\_insights\_application\_type | Application Type of the associated Application Insights |
| monitoring\_function\_application\_insights\_id | Id of the associated Application Insights |
| monitoring\_function\_application\_insights\_instrumentation\_key | Instrumentation key of the associated Application Insights |
| monitoring\_function\_application\_insights\_name | Name of the associated Application Insights |
| monitoring\_function\_function\_app\_connection\_string | Connection string of the created Function App |
| monitoring\_function\_function\_app\_id | Id of the created Function App |
| monitoring\_function\_function\_app\_identity | Identity block output of the Function App |
| monitoring\_function\_function\_app\_name | Name of the created Function App |
| monitoring\_function\_function\_app\_outbound\_ip\_addresses | Outbound IP adresses of the created Function App |
| monitoring\_function\_storage\_account\_id | Id of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_name | Name of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_primary\_access\_key | Primary connection string of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_primary\_connection\_string | Primary connection string of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_secondary\_access\_key | Secondary connection string of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_secondary\_connection\_string | Secondary connection string of the associated Storage Account, empty if connection string provided |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure Monitor logs documentation: [docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview)

Microsoft Azure Key Vault documentation: [docs.microsoft.com/en-us/azure/key-vault/](https://docs.microsoft.com/en-us/azure/key-vault/)
