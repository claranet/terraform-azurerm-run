# Azure RUN IaaS/VM
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/run-iaas/azurerm/)

A terraform feature which includes services needed for Claranet RUN/MSP on Azure IaaS resources (VMs).

It includes:
* Azure Backup
    * A Recovery Services Vault to store VM backups ([documentaion](https://docs.microsoft.com/en-us/azure/backup/backup-overview)).
    * A VM backup policy to assign on VM instances (via the [vm-backup](https://git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/vm-backup/) module).

## Requirements

* [Terraform](https://www.terraform.io/downloads.html) >= 0.12
* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.31

## Usage

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

module "run_iaas" {
  source  = "claranet/run-iaas/azurerm"
  version = "x.x.x"
  
  client_name    = var.client_name
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  extra_tags = {
    foo    = "bar"
  }
}
```

## Using sub-modules
The integrated services can be used separately with the same inputs and outputs when it's a sub module.

### Azure Backup
```hcl
module "az-vm-backup" {
  source = "git::ssh://git@github.com/claranet/terraform-azurerm-run-iaas.git//backup?ref=vX.X.X"

  location            = module.az-region.location
  location_short      = module.az-region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack

  resource_group_name = module.rg.resource_group_name

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
| name\_prefix | Name prefix for all resources generated name | string | `""` | no |
| recovery\_vault\_custom\_name | Azure Recovery Vault custom name. Empty by default, using naming convention. | string | `""` | no |
| recovery\_vault\_sku | Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`. | string | `"Standard"` | no |
| resource\_group\_name | Resource Group the resources will belong to | string | n/a | yes |
| stack | Stack name | string | n/a | yes |
| vm\_backup\_policy\_custom\_name | Azure Backup - VM backup policy custom name. Empty by default, using naming convention. | string | `""` | no |
| vm\_backup\_policy\_retention | The number of daily backups to keep. Must be between 1 and 9999. | string | `"30"` | no |
| vm\_backup\_policy\_time | The time of day to preform the backup in 24hour format. | string | `"04:00"` | no |
| vm\_backup\_policy\_timezone | Specifies the timezone for schedules. Defaults to `UTC`. | string | `"UTC"` | no |

## Outputs

| Name | Description |
|------|-------------|
| recovery\_vault\_id | Azure Recovery Services Vault ID |
| recovery\_vault\_name | Azure Recovery Services Vault name |
| vm\_backup\_policy\_id | VM Backup policy ID |
| vm\_backup\_policy\_name | VM Backup policy name |

## Related documentation

- Terraform Azure Recovery Services Vault: [https://www.terraform.io/docs/providers/azurerm/r/recovery_services_vault.html]
- Terraform Azure VM Backup policy: [https://www.terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html]
