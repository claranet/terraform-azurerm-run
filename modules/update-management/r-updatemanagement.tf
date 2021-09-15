resource "azurerm_log_analytics_solution" "update_management" {
  location            = var.location
  resource_group_name = var.resource_group_name

  workspace_name        = split("/", var.log_analytics_workspace_id)[8]
  workspace_resource_id = var.log_analytics_workspace_id

  solution_name = "Updates"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
}

resource "azurerm_template_deployment" "update_config_standard_linux" {
  for_each = contains(toset([for s in var.update_management_os : lower(s)]), "linux") ? toset(["linux"]) : []

  deployment_mode     = "Incremental"
  name                = lower(format("%s-%s", local.arm_update_management_name, "linux"))
  resource_group_name = var.resource_group_name

  template_body = jsonencode({
    "$schema"      = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
    contentVersion = "1.0.0.0"
    resources = [
      {
        type       = "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations"
        apiVersion = "2019-06-01"
        name       = "${var.automation_account_name}/Standard Linux Update Schedule"
        properties = {
          updateConfiguration = {
            operatingSystem = "Linux"
            linux = {
              includedPackageClassifications = lookup(var.linux_update_management_configuration, "update_classifications", "Critical, Security")
              rebootSetting                  = lookup(var.linux_update_management_configuration, "reboot_setting", "IfRequired")
              includedPackageNameMasks       = lookup(var.linux_update_management_configuration, "included_packages", [])
              excludedPackageNameMasks       = lookup(var.linux_update_management_configuration, "excluded_packages", [])
            }
            duration = "${coalesce(var.linux_update_management_duration, var.update_management_duration)}"
            targets = {
              azureQueries = [
                {
                  scope = coalesce(var.linux_update_management_scope, var.update_management_scope, [data.azurerm_subscription.current.id])
                  tagSettings = {
                    tags           = "${coalesce(var.linux_update_management_tags_filtering, var.update_management_tags_filtering)}"
                    filterOperator = "${coalesce(var.linux_update_management_tags_filtering_operator, var.update_management_tags_filtering_operator)}"
                  }
                }
              ]
            }
          }
          scheduleInfo = "${coalesce(try(var.linux_update_management_schedule[0], null), var.update_management_schedule[0])}"
        }
      }
    ]
  })
}

resource "azurerm_template_deployment" "update_config_standard_windows" {
  for_each = contains(toset([for s in var.update_management_os : lower(s)]), "windows") ? toset(["windows"]) : []

  deployment_mode     = "Incremental"
  name                = lower(format("%s-%s", local.arm_update_management_name, "windows"))
  resource_group_name = var.resource_group_name

  template_body = jsonencode({
    "$schema"      = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
    contentVersion = "1.0.0.0"
    resources = [
      {
        type       = "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations"
        apiVersion = "2019-06-01"
        name       = "${var.automation_account_name}/Standard Windows Update Schedule"
        properties = {
          updateConfiguration = {
            operatingSystem = "Windows"
            windows = {
              includedUpdateClassifications = lookup(var.windows_update_management_configuration, "update_classifications", "Critical, Security")
              rebootSetting                 = lookup(var.windows_update_management_configuration, "reboot_setting", "IfRequired")
              includedKbNumbers             = lookup(var.windows_update_management_configuration, "included_kb_numbers", [])
              excludedKbNumbers             = lookup(var.windows_update_management_configuration, "excluded_kb_numbers", [])
            }
            duration = "${coalesce(var.windows_update_management_duration, var.update_management_duration)}"
            targets = {
              azureQueries = [
                {
                  scope = coalesce(var.windows_update_management_scope, var.update_management_scope, [data.azurerm_subscription.current.id])
                  tagSettings = {
                    tags           = "${coalesce(var.windows_update_management_tags_filtering, var.update_management_tags_filtering)}"
                    filterOperator = "${coalesce(var.windows_update_management_tags_filtering_operator, var.update_management_tags_filtering_operator)}"
                  }
                }
              ]
            }
          }
          scheduleInfo = "${coalesce(try(var.windows_update_management_schedule[0], null), var.update_management_schedule[0])}"
        }
      }
    ]
  })
}

data "azurerm_subscription" "current" {
}
