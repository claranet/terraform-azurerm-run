# Azure Backup - Recovery service vault

It includes:
* Azure Backup
    * A Recovery Services Vault to store VM backups ([documentaion](https://docs.microsoft.com/en-us/azure/backup/backup-overview)).
    * A VM backup policy to assign on VM instances (via the [vm-backup](https://registry.terraform.io/modules/claranet/vm-backup/) module).

## Requirements

* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.32

## Terraform version compatibility

| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| <  2.x.x       | 0.11.x            |

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

module "az-vm-backup" {
  source  = "claranet/run-iaas/azurerm//modules/backup"
  version = "x.x.x"

  location            = module.az-region.location
  location_short      = module.az-region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack

  resource_group_name = module.rg.resource_group_name

  extra_tags = {
    foo = "bar"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client\_name | Client name | string | n/a | yes |
| environment | Environment name | string | n/a | yes |
| extra\_tags | Extra tags to add | map(string) | `{}` | no |
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

- Terraform Azure Recovery Services Vault: [terraform.io/docs/providers/azurerm/r/recovery_services_vault.html](https://www.terraform.io/docs/providers/azurerm/r/recovery_services_vault.html)
- Terraform Azure VM Backup policy: [terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html](https://www.terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html)
