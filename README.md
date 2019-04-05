# Azure Global resources

A terraform feature which includes services needed for Claranet RUN/MSP.
It includes:
 - Log Analytics Workspace
 - Storage Account with SAS Token to upload logs to

## Usage

```shell

module "azure-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = "${var.azure_region}"
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  location    = "${module.azure-region.location}"
  client_name = "inativ"
  environment = "${var.environment}"
  stack       = "${var.stack}"
}

module "global_run" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/global-run.git?ref=vX.X.X"

  client_name         = "${var.client_name}"
  location            = "${module.azure-region.location}"
  location_short      = "${module.azure-region.location-short}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${module.rg.resource_group_name}"

  storage_account_sas_expiry = "2021-04-04T00:00:00Z"
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client_name | Global variables | string | - | yes |
| create_storage_account_resource | Flag indicating if Storage Account resource should be automatically created (needed until Terraform 0.12), otherwise, variable `storage_account_connection_string` must be set. Default to `true` | string | `true` | no |
| environment | - | string | - | yes |
| extra_tags | Extra tags to add | map | `<map>` | no |
| location | Azure location for App Service Plan. | string | - | yes |
| location_short | Short string for Azure location. | string | - | yes |
| log_analytics_custom_name | Azure log analytics custom name. Empty by default, using naming convention. | string | `` | no |
| log_analytics_retention_in_days | The workspace data retention in days. Possible values range between 30 and 730. | string | `30` | no |
| log_analytics_sku | Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03). | string | `PerGB2018` | no |
| name_prefix | Name prefix for all resources generated name | string | `` | no |
| resource_group_name | - | string | - | yes |
| stack | - | string | - | yes |
| storage_account_connection_string | Storage Account connection string for Function App associated storage, a Storage Account is created if empty | string | `` | no |
| storage_account_extra_tags | Extra tags to add to Storage Account | map | `<map>` | no |
| storage_account_name_suffix | Storage Account name suffix | string | `` | no |
| storage_account_sas_expiry | Storage Account SAS Token - end date (expiry). Specifies the UTC datetime (Y-m-d'T'H:M'Z') at which the SAS becomes invalid. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| log_analytics_id | The Log Analytics ID. |
| log_analytics_portal_url | The Portal URL for the Log Analytics Workspace. |
| log_analytics_primary_key | The Primary shared key for the Log Analytics Workspace. |
| log_analytics_secondary_key | The Secondary shared key for the Log Analytics Workspace. |
| log_analytics_workspace_id | The Log Analytics Workspace ID. |
| storage_account_id | Id of the associated Storage Account, empty if connection string provided |
| storage_account_name | Name of the associated Storage Account, empty if connection string provided |
| storage_account_primary_access_key | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage_account_primary_connection_string | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage_account_sas_token | SAS Token generated for logs access |
| storage_account_secondary_access_key | Secondary connection string of the associated Storage Account, empty if connection string provided |
| storage_account_secondary_connection_string | Secondary connection string of the associated Storage Account, empty if connection string provided |

## Related documentation

Terraform Azure Log Analytics workspace: https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html
Terraform Azure Storage, SAS Token data source: https://www.terraform.io/docs/providers/azurerm/d/storage_account_sas.html
