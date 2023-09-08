# Azure RUN feature
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/run/azurerm/)

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

It includes some IaaS specifics:
  * Azure Backup ([example](examples/backup/modules.tf))
      * A Recovery Services Vault to store VM backups ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-overview)).
      * A VM backup policy to assign on VM instances (via the [vm-backup](https://registry.terraform.io/modules/claranet/vm-backup/) module).
      * A file share backup policy to assign on [Storage Account file shares](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction) (via the [backup_protected_file_share](https://www.terraform.io/docs/providers/azurerm/r/backup_protected_file_share.html) terraform resource)
      * A diagnostics settings to manage logging ([documentation](https://docs.microsoft.com/en-us/azure/backup/backup-azure-diagnostic-events))
  * An Automation account to execute runbooks ([documentation](https://docs.microsoft.com/fr-fr/azure/automation/automation-intro)) ([example](examples/automation-account/modules.tf))
  * Legacy Azure Update Management using Automation Account ([documentation](https://docs.microsoft.com/en-us/azure/automation/update-management/overview)) ([example](examples/update-management/modules.tf))
  * A Data Collection Rule to gather metrics and logs from Virtual Machines ([documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-collection-rule-overview))
  * Azure Update Center using Update Management Center ([documentation](https://learn.microsoft.com/en-us/azure/update-center/overview)) ([example](examples/update-management-center/modules.tf))

## Requirements

* You need to have at least the `Contributor` role on the subscriptions to use `update_center_periodic_assessment_enabled` with Update Management Center module.

## Using sub-modules

The integrated services can be used separately with the same inputs and outputs when it's a sub-module.

### Log management

See `logs` module [README](./modules/logs/README.md).

### Monitoring function

See `monitoring_function` module [README](./modules/monitoring\_function/README.md)

### Key Vault

See Key Vault module: [terraform-azurerm-keyvault](https://github.com/claranet/terraform-azurerm-keyvault).

### Azure Backup

See Azure Backup module [README](./modules/backup/README.md).

### Automation Account

See Automation Account module [README](./modules/automation-account/README.md).

### Azure Update

See Update Center module [README](./modules/update-center/README.md) and Update Management module (legacy) [README](./modules/update-management/README.md).

## Migrating from older modules

This `run` module is a merge of the previous [run-common](https://registry.terraform.io/modules/claranet/run-common) and
[run-iaas](https://registry.terraform.io/modules/claranet/run-common) modules.

Some previously pre-activated backup and update management features must now be explicitly enabled through `*_enabled` variables.
You must be on the latest version of `run_iaas` and `run_common` modules before updating to `run` module.

You can migrate your Terrafom state with the following commands:

```shell
terraform state mv module.run_common.module.keyvault module.run.module.keyvault
terraform state mv module.run_common.module.logs module.run.module.logs
terraform state mv 'module.run_common.module.monitoring_function[0]' 'module.run.module.monitoring_function[0]'
terraform state mv module.run_iaas.module.automation_account 'module.run.module.automation_account[0]'
terraform state mv module.run_iaas.module.backup 'module.run.module.backup[0]'
terraform state mv module.run_iaas.module.update_management 'module.run.module.update_management[0]'
terraform state mv 'module.run_iaas.module.update_management_center["enabled"]' 'module.run.module.update_management_center["enabled"]'
terraform state mv module.run_iaas.module.vm_monitoring 'module.run.module.vm_monitoring[0]'
terraform state mv 'module.run_common.azurerm_role_assignment.function_workspace[0]' 'module.run.azurerm_role_assignment.function_workspace[0]'
terraform apply -target='module.run.null_resource.fake_function_condition[0]'
```

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

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

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  monitoring_function_splunk_token = "xxxxxx"
  monitoring_function_metrics_extra_dimensions = {
    env           = var.environment
    sfx_monitored = "true"
  }

  backup_vm_enabled         = true
  backup_postgresql_enabled = true

  update_center_enabled = true

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.64 |
| null | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| automation\_account | ./modules/automation-account | n/a |
| backup | ./modules/backup | n/a |
| keyvault | claranet/keyvault/azurerm | ~> 7.5.0 |
| logs | ./modules/logs | n/a |
| monitoring\_function | ./modules/monitoring-function | n/a |
| update\_management | ./modules/update-management | n/a |
| update\_management\_center | ./modules/update-center | n/a |
| vm\_monitoring | ./modules/vm-monitoring | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.function_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.function_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [null_resource.fake_function_condition](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automation\_account\_enabled | Whether to enable Automation Account. Enabled if legacy Update Management is enabled. | `bool` | `false` | no |
| automation\_account\_extra\_tags | Extra tags to add to Automation Account. | `map(string)` | `{}` | no |
| automation\_account\_identity\_type | Automation Account identity type. Possible values include: `null`, `SystemAssigned` and `UserAssigned`. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| automation\_account\_sku | Automation account Sku. | `string` | `"Basic"` | no |
| automation\_custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| automation\_logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| automation\_logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | `[]` | no |
| automation\_logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| backup\_custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| backup\_file\_share\_enabled | Whether the File Share backup is enabled. | `bool` | `false` | no |
| backup\_logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| backup\_logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | `[]` | no |
| backup\_logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| backup\_managed\_disk\_enabled | Whether the Managed Disk backup is enabled. | `bool` | `false` | no |
| backup\_postgresql\_enabled | Whether the PostgreSQL backup is enabled. | `bool` | `false` | no |
| backup\_storage\_blob\_enabled | Whether the Storage blob backup is enabled. | `bool` | `false` | no |
| backup\_vault\_custom\_name | Azure Backup Vault custom name. Empty by default, using naming convention. | `string` | `""` | no |
| backup\_vault\_datastore\_type | Type of data store used for the Backup Vault. | `string` | `"VaultStore"` | no |
| backup\_vault\_extra\_tags | Extra tags to add to Backup Vault. | `map(string)` | `{}` | no |
| backup\_vault\_geo\_redundancy\_enabled | Whether the geo redundancy is enabled no the Backup Vault. | `bool` | `true` | no |
| backup\_vault\_identity\_type | Azure Backup Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`. | `string` | `"SystemAssigned"` | no |
| backup\_vm\_enabled | Whether the Virtual Machines backup is enabled. | `bool` | `false` | no |
| client\_name | Client name. | `string` | n/a | yes |
| custom\_automation\_account\_name | Automation account custom name. | `string` | `""` | no |
| data\_collection\_syslog\_facilities\_names | List of syslog to retrieve in Data Collection Rule. | `list(string)` | <pre>[<br>  "auth",<br>  "authpriv",<br>  "cron",<br>  "daemon",<br>  "mark",<br>  "kern",<br>  "local0",<br>  "local1",<br>  "local2",<br>  "local3",<br>  "local4",<br>  "local5",<br>  "local6",<br>  "local7",<br>  "lpr",<br>  "mail",<br>  "news",<br>  "syslog",<br>  "user",<br>  "uucp"<br>]</pre> | no |
| data\_collection\_syslog\_levels | List of syslog levels to retrieve in Data Collection Rule. | `list(string)` | <pre>[<br>  "Error",<br>  "Critical",<br>  "Alert",<br>  "Emergency"<br>]</pre> | no |
| dcr\_custom\_name | VM Monitoring - Data Collection rule custom name. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| deploy\_update\_management\_solution | Should we deploy the Log Analytics Update solution or not. | `bool` | `true` | no |
| environment | Environment name. | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| file\_share\_backup\_daily\_policy\_retention | The number of daily file share backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| file\_share\_backup\_monthly\_retention | Map to configure the monthly File Share backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_monthly | <pre>object({<br>    count    = number,<br>    weekdays = list(string),<br>    weeks    = list(string),<br>  })</pre> | `null` | no |
| file\_share\_backup\_policy\_custom\_name | Azure Backup - File share backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| file\_share\_backup\_policy\_frequency | Specifies the frequency for file\_share backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| file\_share\_backup\_policy\_time | The time of day to perform the file share backup in 24hour format. | `string` | `"04:00"` | no |
| file\_share\_backup\_policy\_timezone | Specifies the timezone for file share backup schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| file\_share\_backup\_weekly\_retention | Map to configure the weekly File Share backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_weekly | <pre>object({<br>    count    = number,<br>    weekdays = list(string),<br>  })</pre> | `null` | no |
| file\_share\_backup\_yearly\_retention | Map to configure the yearly File Share backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_yearly | <pre>object({<br>    count    = number,<br>    weekdays = list(string),<br>    weeks    = list(string),<br>    months   = list(string),<br>  })</pre> | `null` | no |
| keyvault\_admin\_objects\_ids | Ids of the objects that can do all operations on all keys, secrets and certificates | `list(string)` | `[]` | no |
| keyvault\_custom\_name | Name of the Key Vault, generated if not set. | `string` | `""` | no |
| keyvault\_enabled\_for\_deployment | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| keyvault\_enabled\_for\_disk\_encryption | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| keyvault\_enabled\_for\_template\_deployment | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| keyvault\_extra\_tags | Extra tags to add to the Key Vault | `map(string)` | `{}` | no |
| keyvault\_logs\_categories | Log categories to send to destinations. All by default. | `list(string)` | `null` | no |
| keyvault\_logs\_metrics\_categories | Metrics categories to send to destinations. All by default. | `list(string)` | `null` | no |
| keyvault\_managed\_hardware\_security\_module\_enabled | Create a KeyVault Managed HSM resource if enabled. Changing this forces a new resource to be created. | `bool` | `false` | no |
| keyvault\_network\_acls | Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more informations. | <pre>object({<br>    bypass                     = optional(string, "None"),<br>    default_action             = optional(string, "Deny"),<br>    ip_rules                   = optional(list(string)),<br>    virtual_network_subnet_ids = optional(list(string)),<br>  })</pre> | `{}` | no |
| keyvault\_public\_network\_access\_enabled | Whether the Key Vault is available from public network. | `bool` | `false` | no |
| keyvault\_rbac\_authorization\_enabled | Whether the Key Vault uses Role Based Access Control (RBAC) for authorization of data actions instead of access policies. | `bool` | `false` | no |
| keyvault\_reader\_objects\_ids | Ids of the objects that can read all keys, secrets and certificates | `list(string)` | `[]` | no |
| keyvault\_resource\_group\_name | Resource Group the Key Vault will belong to. Will use `resource_group_name` if not set. | `string` | `""` | no |
| keyvault\_sku | The Name of the SKU used for this Key Vault. Possible values are "standard" and "premium". | `string` | `"standard"` | no |
| keyvault\_soft\_delete\_retention\_days | The number of days that items should be retained for once soft-deleted. This value can be between `7` and `90` days. | `number` | `7` | no |
| linux\_update\_management\_config\_name | Custom configuration name for Linux Update management. | `string` | `"Standard Linux Update Schedule"` | no |
| linux\_update\_management\_configuration | Linux specific update management configuration. Possible values for reboot\_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#linuxproperties). | `any` | <pre>{<br>  "excluded_packages": [],<br>  "included_packages": [],<br>  "reboot_setting": "IfRequired",<br>  "update_classifications": "Critical, Security"<br>}</pre> | no |
| linux\_update\_management\_duration | To set the maintenance window for Linux machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H). | `string` | `null` | no |
| linux\_update\_management\_schedule | Map of specific schedule parameters for update management of Linux machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object). | `list(any)` | `null` | no |
| linux\_update\_management\_scope | Scope of the update management for Linux machines, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `null` | no |
| linux\_update\_management\_tags\_filtering | Filter scope for Linux machines using tags on VMs. Example :<pre>{ os_family = ["linux"] }</pre>. | `map(any)` | `null` | no |
| linux\_update\_management\_tags\_filtering\_operator | Filter Linux VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`. | `string` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_resource\_group\_name | Log Analytics Workspace resource group name (if different from `resource_group_name` variable.). | `string` | `null` | no |
| log\_analytics\_workspace\_custom\_name | Azure Log Analytics Workspace custom name. Empty by default, using naming convention. | `string` | `""` | no |
| log\_analytics\_workspace\_extra\_tags | Extra tags to add to the Log Analytics Workspace | `map(string)` | `{}` | no |
| log\_analytics\_workspace\_id | Log Analytics Workspace ID where the logs are sent and linked to Automation account. | `string` | `null` | no |
| log\_analytics\_workspace\_link\_enabled | Enable Log Analytics Workspace that will be connected with the automation account. | `bool` | `true` | no |
| log\_analytics\_workspace\_name\_prefix | Log Analytics name prefix | `string` | `""` | no |
| log\_analytics\_workspace\_retention\_in\_days | The workspace data retention in days. Possible values range between 30 and 730. | `number` | `30` | no |
| log\_analytics\_workspace\_sku | Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03). | `string` | `"PerGB2018"` | no |
| logs\_delete\_after\_days\_since\_modification\_greater\_than | Delete blob after x days without modification | `number` | `365` | no |
| logs\_resource\_group\_name | Resource Group the resources for log management will belong to. Will use `resource_group_name` if not set. | `string` | `""` | no |
| logs\_storage\_account\_access\_tier | Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`. | `string` | `"Hot"` | no |
| logs\_storage\_account\_archived\_logs\_fileshare\_name | Name of the file share in which externalized logs are stored | `string` | `"archived-logs"` | no |
| logs\_storage\_account\_archived\_logs\_fileshare\_quota | The maximum size in GB of the archived-logs file share, default is 5120 | `number` | `null` | no |
| logs\_storage\_account\_custom\_name | Storage Account for logs custom name. Empty by default, using naming convention. | `string` | `""` | no |
| logs\_storage\_account\_enable\_advanced\_threat\_protection | Enable/disable Advanced Threat Protection, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information. | `bool` | `false` | no |
| logs\_storage\_account\_enable\_archived\_logs\_fileshare | Enable/disable archived-logs file share creation | `bool` | `false` | no |
| logs\_storage\_account\_enable\_archiving | Enable/disable blob archiving lifecycle | `bool` | `true` | no |
| logs\_storage\_account\_enable\_https\_traffic\_only | Enable/disable HTTPS traffic only | `bool` | `true` | no |
| logs\_storage\_account\_enabled | Whether the dedicated Storage Account for logs is created. | `bool` | `true` | no |
| logs\_storage\_account\_extra\_tags | Extra tags to add to the logs Storage Account | `map(string)` | `{}` | no |
| logs\_storage\_account\_kind | Storage Account Kind | `string` | `"StorageV2"` | no |
| logs\_storage\_account\_name\_prefix | Storage Account name prefix | `string` | `""` | no |
| logs\_storage\_account\_replication\_type | Storage Account Replication type | `string` | `"LRS"` | no |
| logs\_storage\_account\_tier | Storage Account tier | `string` | `"Standard"` | no |
| logs\_storage\_min\_tls\_version | Storage Account minimal TLS version | `string` | `"TLS1_2"` | no |
| logs\_tier\_to\_archive\_after\_days\_since\_modification\_greater\_than | Change blob tier to Archive after x days without modification | `number` | `90` | no |
| logs\_tier\_to\_cool\_after\_days\_since\_modification\_greater\_than | Change blob tier to cool after x days without modification | `number` | `30` | no |
| managed\_disk\_backup\_daily\_policy\_retention\_in\_days | The number of days to keep the first daily Managed Disk backup. | `number` | `null` | no |
| managed\_disk\_backup\_policy\_custom\_name | Azure Backup - Managed disk backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| managed\_disk\_backup\_policy\_interval\_in\_hours | The Managed Disk backup interval in hours. | `string` | `24` | no |
| managed\_disk\_backup\_policy\_retention\_in\_days | The number of days to keep the Managed Disk backup. | `number` | `30` | no |
| managed\_disk\_backup\_policy\_time | The time of day to perform the Managed Disk backup in 24 hours format (eg 04:00). | `string` | `"04:00"` | no |
| managed\_disk\_backup\_weekly\_policy\_retention\_in\_weeks | The number of weeks to keep the first weekly Managed Disk backup. | `number` | `null` | no |
| monitoring\_function\_advanced\_threat\_protection\_enabled | FAME function app's storage account: Enable Advanced Threat Protection | `bool` | `false` | no |
| monitoring\_function\_app\_service\_plan\_name | FAME App Service Plan custom name. Empty by default, using naming convention. | `string` | `null` | no |
| monitoring\_function\_application\_insights\_custom\_name | FAME Application Insights custom name. Empty by default, using naming convention | `string` | `null` | no |
| monitoring\_function\_assign\_roles | True to assign roles for the monitoring Function on the Log Analytics Workspace (Log Analytics Reader) and the Subscription (Reader). | `bool` | `true` | no |
| monitoring\_function\_enabled | Whether additional Monitoring Function is enabled. | `bool` | `true` | no |
| monitoring\_function\_extra\_application\_settings | Extra application settings to set on monitoring Function | `map(string)` | `{}` | no |
| monitoring\_function\_extra\_tags | Monitoring function extra tags to add | `map(string)` | `{}` | no |
| monitoring\_function\_function\_app\_custom\_name | FAME Function App custom name. Empty by default, using naming convention. | `string` | `null` | no |
| monitoring\_function\_logs\_categories | Monitoring function log categories to send to destinations. All by default. | `list(string)` | `null` | no |
| monitoring\_function\_logs\_metrics\_categories | Monitoring function metrics categories to send to destinations. All by default. | `list(string)` | `null` | no |
| monitoring\_function\_metrics\_extra\_dimensions | Extra dimensions sent with metrics | `map(string)` | `{}` | no |
| monitoring\_function\_splunk\_token | Access Token to send metrics to Splunk Observability | `string` | `null` | no |
| monitoring\_function\_storage\_account\_custom\_name | FAME Storage Account custom name. Empty by default, using naming convention. | `string` | `null` | no |
| monitoring\_function\_zip\_package\_path | Zip package path for monitoring function | `string` | `"https://github.com/claranet/fame/releases/download/v1.2.0/fame.zip"` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| postgresql\_backup\_daily\_policy\_retention\_in\_days | The number of days to keep the first daily Postgresql backup. | `number` | `null` | no |
| postgresql\_backup\_monthly\_policy\_retention\_in\_months | The number of months to keep the first monthly Postgresql backup. | `number` | `null` | no |
| postgresql\_backup\_policy\_custom\_name | Azure Backup - PostgreSQL backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| postgresql\_backup\_policy\_interval\_in\_hours | The Postgresql backup interval in hours. | `string` | `24` | no |
| postgresql\_backup\_policy\_retention\_in\_days | The number of days to keep the Postgresql backup. | `number` | `30` | no |
| postgresql\_backup\_policy\_time | The time of day to perform the Postgresql backup in 24 hours format (eg 04:00). | `string` | `"04:00"` | no |
| postgresql\_backup\_weekly\_policy\_retention\_in\_weeks | The number of weeks to keep the first weekly Postgresql backup. | `number` | `null` | no |
| recovery\_vault\_cross\_region\_restore\_enabled | Is cross region restore enabled for this Vault? Only can be `true`, when `storage_mode_type` is `GeoRedundant`. Defaults to `false`. | `bool` | `true` | no |
| recovery\_vault\_custom\_name | Azure Recovery Vault custom name. Empty by default, using naming convention. | `string` | `""` | no |
| recovery\_vault\_extra\_tags | Extra tags to add to Recovery Vault. | `map(string)` | `{}` | no |
| recovery\_vault\_identity\_type | Azure Recovery Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`. | `string` | `"SystemAssigned"` | no |
| recovery\_vault\_sku | Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`. | `string` | `"Standard"` | no |
| recovery\_vault\_soft\_delete\_enabled | Is soft delete enable for this Vault? Defaults to `true`. | `bool` | `true` | no |
| recovery\_vault\_storage\_mode\_type | The storage type of the Recovery Services Vault. Possible values are `GeoRedundant`, `LocallyRedundant` and `ZoneRedundant`. Defaults to `GeoRedundant`. | `string` | `"GeoRedundant"` | no |
| resource\_group\_name | Resource Group the resources will belong to. | `string` | n/a | yes |
| stack | Stack name. | `string` | n/a | yes |
| storage\_blob\_backup\_policy\_custom\_name | Azure Backup - Storage blob backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| storage\_blob\_backup\_policy\_retention\_in\_days | The number of days to keep the Storage blob backup. | `number` | `30` | no |
| tenant\_id | Tenant ID. | `string` | `null` | no |
| update\_center\_enabled | Whether the Update Management Center is enabled. | `bool` | `false` | no |
| update\_center\_maintenance\_configurations | Update Management Center maintenance configurations. https://learn.microsoft.com/en-us/azure/virtual-machines/maintenance-configurations. | <pre>list(object({<br>    configuration_name = string<br>    start_date_time    = string<br>    duration           = optional(string, "02:00")<br>    time_zone          = optional(string, "UTC")<br>    recur_every        = string<br>    reboot_setting     = optional(string, "IfRequired")<br>    windows_classifications_to_include = optional(list(string), [<br>      "Critical",<br>      "Definition",<br>      "FeaturePack",<br>      "Security",<br>      "ServicePack",<br>      "Tools",<br>      "UpdateRollup",<br>      "Updates",<br>    ])<br>    linux_classifications_to_include = optional(list(string), [<br>      "Critical",<br>      "Security",<br>      "Other",<br>    ])<br>    windows_kb_ids_to_exclude      = optional(list(string), [])<br>    linux_package_names_to_exclude = optional(list(string), [])<br>  }))</pre> | `[]` | no |
| update\_center\_periodic\_assessment\_enabled | Enable auto-assessment (every 24 hours) for OS updates on native Azure virtual machines by assigning Azure Policy. | `bool` | `true` | no |
| update\_center\_periodic\_assessment\_exclusions | Exclude some resources from auto-assessment. | `list(string)` | `[]` | no |
| update\_center\_periodic\_assessment\_scopes | Scope to assign the Azure Policy for auto-assessment. Can be Management Groups, Subscriptions, Resource Groups or Virtual Machines. | `list(string)` | `[]` | no |
| update\_management\_duration | To set the maintenance window, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H). | `string` | `"PT2H"` | no |
| update\_management\_legacy\_enabled | Whether the legacy Update Management is enabled. This enable the Automation Account feature. | `bool` | `false` | no |
| update\_management\_name\_prefix | Name prefix to apply on Update Management resources. | `string` | `null` | no |
| update\_management\_os\_list | List of OS to cover. Possible values can be `Windows` or `Linux`. Define empty list to disable update management. | `list(string)` | `[]` | no |
| update\_management\_schedule | List of Map with schedule parameters for update management. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object). | `list(any)` | `[]` | no |
| update\_management\_scope | Scope of the update management, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `null` | no |
| update\_management\_tags\_filtering | Filter scope using tags on VMs. Example :<pre>{ os_family = ["linux"] }</pre>. | `map(any)` | `{}` | no |
| update\_management\_tags\_filtering\_operator | Filter VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`. | `string` | `"Any"` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `*custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| vm\_backup\_daily\_policy\_retention | The number of daily VM backups to keep. Must be between 7 and 9999. | `number` | `30` | no |
| vm\_backup\_monthly\_retention | Map to configure the monthly VM backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_monthly | <pre>object({<br>    count    = number,<br>    weekdays = list(string),<br>    weeks    = list(string),<br>  })</pre> | `null` | no |
| vm\_backup\_policy\_custom\_name | Azure Backup - VM backup policy custom name. Empty by default, using naming convention. | `string` | `""` | no |
| vm\_backup\_policy\_frequency | Specifies the frequency for VM backup schedules. Must be either `Daily` or `Weekly`. | `string` | `"Daily"` | no |
| vm\_backup\_policy\_time | The time of day to perform the VM backup in 24hour format. | `string` | `"04:00"` | no |
| vm\_backup\_policy\_timezone | Specifies the timezone for VM backup schedules. Defaults to `UTC`. | `string` | `"UTC"` | no |
| vm\_backup\_policy\_type | Type of the Backup Policy. Possible values are `V1` and `V2` where `V2` stands for the Enhanced Policy. Defaults to `V1`. Changing this forces a new resource to be created. | `string` | `"V1"` | no |
| vm\_backup\_weekly\_retention | Map to configure the weekly VM backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_weekly | <pre>object({<br>    count    = number,<br>    weekdays = list(string),<br>  })</pre> | `null` | no |
| vm\_backup\_yearly\_retention | Map to configure the yearly VM backup policy retention according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_yearly | <pre>object({<br>    count    = number,<br>    weekdays = list(string),<br>    weeks    = list(string),<br>    months   = list(string),<br>  })</pre> | `null` | no |
| vm\_monitoring\_enabled | Whether Data Collection Rules for VM monitoring are enabled. | `bool` | `false` | no |
| windows\_update\_management\_configuration | Windows specific update management configuration. Possible values for reboot\_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#windowsproperties). | `any` | <pre>{<br>  "excluded_kb_numbers": [],<br>  "included_kb_numbers": [],<br>  "reboot_setting": "IfRequired",<br>  "update_classifications": "Critical, Security"<br>}</pre> | no |
| windows\_update\_management\_configuration\_name | Custom configuration name for Windows Update management. | `string` | `"Standard Windows Update Schedule"` | no |
| windows\_update\_management\_duration | To set the maintenance window for Windows machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H). | `string` | `null` | no |
| windows\_update\_management\_schedule | Map of specific schedule parameters for update management of Windows machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object). | `list(any)` | `null` | no |
| windows\_update\_management\_scope | Scope of the update management for Windows machines, it can be a subscription ID, a resource group ID etc.. | `list(string)` | `null` | no |
| windows\_update\_management\_tags\_filtering | Filter scope for Windows machines using tags on VMs. Example :<pre>{ os_family = ["windows"] }</pre>. | `map(any)` | `null` | no |
| windows\_update\_management\_tags\_filtering\_operator | Filter Windows VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| automation\_account\_dsc\_primary\_access\_key | Azure Automation Account DSC primary access key. |
| automation\_account\_dsc\_secondary\_access\_key | Azure Automation Account DSC secondary access key. |
| automation\_account\_dsc\_server\_endpoint | Azure Automation Account DSC server endpoint. |
| automation\_account\_id | Azure Automation Account ID. |
| automation\_account\_identity | Identity block with principal ID and tenant ID |
| automation\_account\_name | Azure Automation Account name. |
| backup\_vault\_id | Azure Backup Vault ID. |
| backup\_vault\_identity | Azure Backup Services Vault identity. |
| backup\_vault\_name | Azure Backup Vault name. |
| data\_collection\_rule | Azure Monitor Data Collection Rule object. |
| data\_collection\_rule\_id | ID of the Azure Monitor Data Collection Rule. |
| data\_collection\_rule\_name | Name of the Azure Monitor Data Collection Rule. |
| file\_share\_backup\_policy\_id | File share Backup policy ID. |
| file\_share\_backup\_policy\_name | File share Backup policy name. |
| key\_vault\_hsm\_uri | The URI of the Key Vault Managed Hardware Security Module, used for performing operations on keys. |
| keyvault\_id | ID of the Key Vault. |
| keyvault\_name | Name of the Key Vault. |
| keyvault\_resource\_group\_name | Resource Group of the Key Vault. |
| keyvault\_uri | URI of the Key Vault. |
| log\_analytics\_workspace\_guid | The Log Analytics Workspace GUID. |
| log\_analytics\_workspace\_id | The Log Analytics Workspace ID. |
| log\_analytics\_workspace\_location | The Log Analytics Workspace location. |
| log\_analytics\_workspace\_name | The Log Analytics Workspace name. |
| log\_analytics\_workspace\_primary\_key | The primary shared key for the Log Analytics Workspace. |
| log\_analytics\_workspace\_secondary\_key | The secondary shared key for the Log Analytics Workspace. |
| logs\_resource\_group\_name | Resource Group of the logs resources. |
| logs\_storage\_account\_archived\_logs\_fileshare\_name | Name of the file share in which externalized logs are stored. |
| logs\_storage\_account\_id | ID of the logs Storage Account. |
| logs\_storage\_account\_name | Name of the logs Storage Account. |
| logs\_storage\_account\_primary\_access\_key | Primary connection string of the logs Storage Account. |
| logs\_storage\_account\_primary\_connection\_string | Primary connection string of the logs Storage Account. |
| logs\_storage\_account\_secondary\_access\_key | Secondary connection string of the logs Storage Account. |
| logs\_storage\_account\_secondary\_connection\_string | Secondary connection string of the logs Storage Account. |
| maintenance\_configurations | Update Center Maintenance Configurations information. |
| managed\_disk\_backup\_policy\_id | Managed disk Backup policy ID. |
| monitoring\_function\_application\_insights\_app\_id | App ID of the associated Application Insights |
| monitoring\_function\_application\_insights\_application\_type | Application Type of the associated Application Insights |
| monitoring\_function\_application\_insights\_id | ID of the associated Application Insights |
| monitoring\_function\_application\_insights\_instrumentation\_key | Instrumentation key of the associated Application Insights |
| monitoring\_function\_application\_insights\_name | Name of the associated Application Insights |
| monitoring\_function\_function\_app\_connection\_string | Connection string of the created Function App |
| monitoring\_function\_function\_app\_id | ID of the created Function App |
| monitoring\_function\_function\_app\_identity | Identity block output of the Function App |
| monitoring\_function\_function\_app\_name | Name of the created Function App |
| monitoring\_function\_function\_app\_outbound\_ip\_addresses | Outbound IP addresses of the created Function App |
| monitoring\_function\_service\_plan\_id | Id of the created Service Plan |
| monitoring\_function\_service\_plan\_name | Name of the created Service Plan |
| monitoring\_function\_storage\_account\_id | ID of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_name | Name of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_primary\_access\_key | Primary connection string of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_primary\_connection\_string | Primary connection string of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_secondary\_access\_key | Secondary connection string of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_account\_secondary\_connection\_string | Secondary connection string of the associated Storage Account, empty if connection string provided |
| monitoring\_function\_storage\_queries\_table\_name | Name of the queries table in the Storage Account, empty if connection string provided |
| postgresql\_backup\_policy\_id | PostgreSQL Backup policy ID. |
| recovery\_vault\_id | Azure Recovery Services Vault ID. |
| recovery\_vault\_identity | Azure Recovery Services Vault identity. |
| recovery\_vault\_name | Azure Recovery Services Vault name. |
| storage\_blob\_backup\_policy\_id | Storage blob Backup policy ID. |
| terraform\_module | Information about this Terraform module |
| vm\_backup\_policy\_id | VM Backup policy ID. |
| vm\_backup\_policy\_name | VM Backup policy name. |
<!-- END_TF_DOCS -->
## Related documentation

- Microsoft Azure Monitor logs documentation: [docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview)
- Microsoft Azure Key Vault documentation: [docs.microsoft.com/en-us/azure/key-vault/](https://docs.microsoft.com/en-us/azure/key-vault/)
- Microsoft Update management documentation: [docs.microsoft.com/en-us/azure/automation/update-management/overview](https://docs.microsoft.com/en-us/azure/automation/update-management/overview)
- Microsoft ARM template for Update management documentation: [docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json)
