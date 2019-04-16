# Azure Global resources

## Purpose
A terraform feature which includes services needed for Claranet RUN/MSP.

It includes:
* Log Management with following resources
    * Log Analytics Workspace
    * Storage Account with SAS Token to upload logs to

## Usage

```hcl
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
  
  client_name    = "${var.client_name}"
  location       = "${module.azure-region.location}"
  location_short = "${module.azure-region.location-short}"
  environment    = "${var.environment}"
  stack          = "${var.stack}"

  resource_group_name = "${module.rg.resource_group_name}"

  extra_tags = {
    foo    = "bar"
  }
}
```

## Using sub-modules
Each integrated service can be used separately with the same inputs and outputs.

### Log management
```hcl
module "logs" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/global-services.git//logs?ref=vX.X.X"

  client_name    = "${var.client_name}"
  location       = "${module.azure-region.location}"
  location_short = "${module.azure-region.location-short}"
  environment    = "${var.environment}"
  stack          = "${var.stack}"

  resource_group_name = "${module.rg.resource_group_name}"

  extra_tags = {
    foo    = "bar"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client\_name | Client name | string | n/a | yes |
| environment | Environment name | string | n/a | yes |
| extra\_tags | Extra tags to add | map | `<map>` | no |
| location | Azure location. | string | n/a | yes |
| location\_short | Short string for Azure location. | string | n/a | yes |
| log\_analytics\_workspace\_custom\_name | Azure Log Analytics Workspace custom name. Empty by default, using naming convention. | string | `""` | no |
| log\_analytics\_workspace\_extra\_tags | Extra tags to add to the Log Analytics Workspace | map | `<map>` | no |
| log\_analytics\_workspace\_name\_prefix | Log Analytics name prefix | string | `""` | no |
| log\_analytics\_workspace\_retention\_in\_days | The workspace data retention in days. Possible values range between 30 and 730. | string | `"30"` | no |
| log\_analytics\_workspace\_sku | Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03). | string | `"PerGB2018"` | no |
| logs\_resource\_group\_name | Resource Group the resources for log management will belong to. Will use `resource_group_name` if not set. | string | `""` | no |
| logs\_storage\_account\_custom\_name | Storage Account for logs custom name. Empty by default, using naming convention. | string | `""` | no |
| logs\_storage\_account\_extra\_tags | Extra tags to add to Storage Account | map | `<map>` | no |
| logs\_storage\_account\_name\_prefix | Storage Account name prefix | string | `""` | no |
| logs\_storage\_account\_sas\_expiry | Storage Account SAS Token end date (expiry). Specifies the UTC datetime (Y-m-d'T'H:M'Z') at which the SAS becomes invalid. | string | `"2042-01-01T00:00:00Z"` | no |
| name\_prefix | Name prefix for all resources generated name | string | `""` | no |
| resource\_group\_name | Resource Group the resources will belong to | string | n/a | yes |
| stack | Stack name | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| log\_analytics\_workspace\_guid | The Log Analytics Workspace GUID. |
| log\_analytics\_workspace\_id | The Log Analytics Workspace ID. |
| log\_analytics\_workspace\_portal\_url | The Portal URL for the Log Analytics Workspace. |
| log\_analytics\_workspace\_primary\_key | The Primary shared key for the Log Analytics Workspace. |
| log\_analytics\_workspace\_secondary\_key | The Secondary shared key for the Log Analytics Workspace. |
| logs\_storage\_account\_id | Id of the associated Storage Account |
| logs\_storage\_account\_name | Name of the logs Storage Account |
| logs\_storage\_account\_primary\_access\_key | Primary connection string of the logs Storage Account, empty if connection string provided |
| logs\_storage\_account\_primary\_connection\_string | Primary connection string of the logs Storage Account, empty if connection string provided |
| logs\_storage\_account\_sas\_token | SAS Token generated for logs access on Storage Account with full permissions on containers and objects for blob and table services. |
| logs\_storage\_account\_secondary\_access\_key | Secondary connection string of the logs Storage Account, empty if connection string provided |
| logs\_storage\_account\_secondary\_connection\_string | Secondary connection string of the logs Storage Account, empty if connection string provided |

## Related documentation

Terraform Azure Log Analytics Workspace: [https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html]

Microsoft Azure Monitor logs documentation: [https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/log-query-overview]
