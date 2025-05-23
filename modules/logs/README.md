# Azure Log Management

It includes resources needed for Log Management with following resources:

 * Log Analytics Workspace
 * Storage Account

## Related documentation

Microsoft Azure Monitor logs documentation: [docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview)

Microsoft Azure Storage Account documentation: [docs.microsoft.com/en-us/azure/storage/common/storage-account-overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview)

Microsoft Azure Blob lifecycle management documentation: [docs.microsoft.com/en-us/azure/storage/blobs/storage-lifecycle-management-concepts?tabs=azure-portal](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-lifecycle-management-concepts?tabs=azure-portal)

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
module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2.23 |
| azurerm | ~> 4.9 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| storage | claranet/storage-account/azurerm | ~> 8.6.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_storage_management_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |
| [azurerm_storage_share.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurecaf_name.workspace](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| client\_name | Client name. | `string` | n/a | yes |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| delete\_after\_days\_since\_modification\_greater\_than | Delete blob after x days without modification. | `number` | `365` | no |
| environment | Environment name. | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| rbac\_storage\_blob\_role\_principal\_ids | The principal IDs of the users, groups, and service principals to assign the `Storage Blob Data *` different roles to if Blob containers are created. | <pre>object({<br/>    owners       = optional(list(string), [])<br/>    contributors = optional(list(string), [])<br/>    readers      = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| rbac\_storage\_contributor\_role\_principal\_ids | The principal IDs of the users, groups, and service principals to assign the `Storage Account Contributor` role to. | `list(string)` | `[]` | no |
| resource\_group\_name | Resource group to which the resources will belong. | `string` | n/a | yes |
| stack | Stack name. | `string` | n/a | yes |
| storage\_account\_access\_tier | Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`. | `string` | `"Hot"` | no |
| storage\_account\_advanced\_threat\_protection\_enabled | Enable/disable Advanced Threat Protection, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information. | `bool` | `false` | no |
| storage\_account\_allowed\_copy\_scope | Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Possible values are `AAD` and `PrivateLink`. | `string` | `null` | no |
| storage\_account\_archived\_logs\_fileshare\_enabled | Enable/disable archived-logs file share creation. | `bool` | `false` | no |
| storage\_account\_archived\_logs\_fileshare\_name | Name of the file share in which externalized logs are stored. | `string` | `"archived-logs"` | no |
| storage\_account\_archived\_logs\_fileshare\_quota | The maximum size in GB of the archived-logs file share, default is 5120. | `number` | `null` | no |
| storage\_account\_archiving\_enabled | Enable/disable blob archiving lifecycle. | `bool` | `true` | no |
| storage\_account\_custom\_name | Storage Account for logs custom name. Empty by default, using naming convention. | `string` | `""` | no |
| storage\_account\_customer\_managed\_key | Customer Managed Key. Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#customer_managed_key) for more information. | <pre>object({<br/>    key_vault_key_id          = optional(string)<br/>    managed_hsm_key_id        = optional(string)<br/>    user_assigned_identity_id = optional(string)<br/>  })</pre> | `null` | no |
| storage\_account\_enabled | Whether the dedicated Storage Account for logs is created. | `bool` | `true` | no |
| storage\_account\_extra\_tags | Extra tags to add to the Storage Account | `map(string)` | `{}` | no |
| storage\_account\_https\_traffic\_only\_enabled | Enable/disable HTTPS traffic only. | `bool` | `true` | no |
| storage\_account\_identity\_ids | List of User Assigned Identity IDs to assign to the Storage Account. | `list(string)` | `null` | no |
| storage\_account\_identity\_type | The identity type of the storage account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`. | `string` | `"SystemAssigned"` | no |
| storage\_account\_infrastructure\_encryption\_enabled | Boolean flag which enables infrastructure encryption.  Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#infrastructure_encryption_enabled) for more information. | `bool` | `false` | no |
| storage\_account\_kind | Storage Account Kind. | `string` | `"StorageV2"` | no |
| storage\_account\_min\_tls\_version | Storage Account minimal TLS version. | `string` | `"TLS1_2"` | no |
| storage\_account\_name\_prefix | Storage Account name prefix. | `string` | `""` | no |
| storage\_account\_public\_network\_access\_enabled | Whether the public network access is enabled. | `bool` | `true` | no |
| storage\_account\_replication\_type | Storage Account Replication type. | `string` | `"LRS"` | no |
| storage\_account\_tier | Storage Account tier. | `string` | `"Standard"` | no |
| storage\_shared\_access\_key\_enabled | Indicates whether the Storage Account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Entra ID). | `bool` | `false` | no |
| tier\_to\_archive\_after\_days\_since\_modification\_greater\_than | Change blob tier to Archive after x days without modification. | `number` | `90` | no |
| tier\_to\_cool\_after\_days\_since\_modification\_greater\_than | Change blob tier to cool after x days without modification. | `number` | `30` | no |
| workspace\_custom\_name | Azure Log Analytics Workspace custom name. Empty by default, using naming convention. | `string` | `""` | no |
| workspace\_daily\_quota\_gb | The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited). | `number` | `-1` | no |
| workspace\_extra\_tags | Extra tags to add to the Log Analytics Workspace | `map(string)` | `{}` | no |
| workspace\_name\_prefix | Log Analytics name prefix. | `string` | `""` | no |
| workspace\_retention\_in\_days | The workspace data retention in days. Possible values range between 30 and 730. | `number` | `30` | no |
| workspace\_sku | Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03). | `string` | `"PerGB2018"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The Log Analytics Workspace ID. |
| log\_analytics\_workspace\_guid | The Log Analytics Workspace GUID. |
| log\_analytics\_workspace\_location | The Log Analytics Workspace location. |
| log\_analytics\_workspace\_primary\_key | The Primary shared key for the Log Analytics Workspace. |
| log\_analytics\_workspace\_secondary\_key | The secondary shared key for the Log Analytics Workspace. |
| logs\_resource\_group\_name | Resource Group of the logs resources. |
| module\_storage\_logs | Storage Account for logs module output. |
| name | The Log Analytics Workspace name. |
| resource | Log Analytics Workspace resource object. |
| storage\_account\_archived\_logs\_fileshare\_name | Name of the file share in which externalized logs are stored. |
| storage\_account\_id | ID of the logs Storage Account. |
| storage\_account\_name | Name of the logs Storage Account. |
| storage\_account\_primary\_access\_key | Primary connection string of the logs Storage Account. |
| storage\_account\_primary\_connection\_string | Primary connection string of the logs Storage Account. |
| storage\_account\_secondary\_access\_key | Secondary connection string of the logs Storage Account. |
| storage\_account\_secondary\_connection\_string | Secondary connection string of the logs Storage Account. |
<!-- END_TF_DOCS -->
