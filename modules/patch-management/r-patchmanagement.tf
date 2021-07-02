resource "azurerm_log_analytics_solution" "patch_management" {
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

resource "azurerm_template_deployment" "update_config_standard_patch_linux" {
  deployment_mode     = "Incremental"
  name                = format("%s-%s", local.arm_patch_mngt_name, "linux")
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
              includedPackageClassifications : "${join(", ", var.patch_mgmt_update_classifications)}"
              rebootSetting = "${var.patch_mgmt_reboot_setting}"
            }
            duration = "${var.patch_mgmt_duration}"
            targets = {
              azureQueries = [
                {
                  scope = "${var.patch_mgmt_scope}"
                  tagSettings = {
                    tags           = "${var.patch_mgmt_tags_filtering}"
                    filterOperator = "${var.patch_mgmt_tags_filtering_operator}"
                  }
                }
              ]
            }
          }
          scheduleInfo = "${var.patch_mgmt_schedule[0]}"
        }
      }
    ]
  })
}
