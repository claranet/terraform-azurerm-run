# Azure Update Management Center

It includes:
* Azure Update Management Center (preview) ([documentation](https://learn.microsoft.com/en-us/azure/update-center/overview))
* Azure policy assignement to enable periodic assessment ([documentation](https://learn.microsoft.com/en-us/azure/update-center/assessment-options))

## Requirements

* During the preview you have to register for `InGuestAutoAssessmentVMPreview` [documentation](https://learn.microsoft.com/en-us/azure/update-center/enable-machines?tabs=portal-periodic)

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azapi | ~> 1.0 |
| azurerm | ~> 3.22 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.maintenance_configurations](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_management_group_policy_assignment.update_check_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.update_check_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.update_check_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.update_check_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_policy_assignment.update_check_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) | resource |
| [azurerm_resource_policy_assignment.update_check_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) | resource |
| [azurerm_subscription_policy_assignment.update_check_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurerm_subscription_policy_assignment.update_check_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_assessment\_enabled | Enable auto-assessment (every 24 hours) for OS updates on native Azure virtual machines by assigning Azure Policy. | `bool` | `true` | no |
| auto\_assessment\_exclusions | Exclude some resources from auto-assessment. | `list(string)` | `[]` | no |
| auto\_assessment\_scopes | Scope to assign the Azure Policy for auto-assessment. Can be Management Groups, Subscriptions, Resource Groups or Virtual Machines. | `list(string)` | `[]` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Environment name. | `string` | n/a | yes |
| extra\_tags | Additional tags to add | `map(string)` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| maintenance\_configurations | Maintenance configurations. https://learn.microsoft.com/en-us/azure/virtual-machines/maintenance-configurations | <pre>list(object({<br>    configuration_name = string<br>    start_date_time    = string<br>    duration           = optional(string, "02:00")<br>    time_zone          = optional(string, "UTC")<br>    recur_every        = string<br>    reboot_setting     = optional(string, "IfRequired")<br>    windows_classifications_to_include = optional(list(string), [<br>      "Critical",<br>      "Definition",<br>      "FeaturePack",<br>      "Security",<br>      "ServicePack",<br>      "Tools",<br>      "UpdateRollup",<br>      "Updates"<br>    ])<br>    linux_classifications_to_include = optional(list(string), [<br>      "Critical",<br>      "Security",<br>      "Other",<br>    ])<br>  }))</pre> | `[]` | no |
| resource\_group\_name | Resource Group the resources will belong to. | `string` | n/a | yes |
| stack | Stack name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| maintenance\_configurations | Maintenance Configurations informations. |
<!-- END_TF_DOCS -->
