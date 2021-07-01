resource "azurerm_log_analytics_solution" "patch_management" {
  count = var.enable_patch_management ? 1 : 0

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
  count = var.enable_patch_management ? 1 : 0

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
        name       = "${module.automation-account.automation_account_name}/Standard Linux Update Schedule"
        properties = {
          updateConfiguration = {
            operatingSystem = "Linux"
            linux = {
              includedPackageClassifications : "${var.patch_mgmt_update_classifications}"
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

# Add a runbook that updates all Azure modules
# Leaving the default name allows to use the "Update" button on the portal to manually run an update runbook
resource "azurerm_automation_runbook" "default-update-modules-runbook" {
  count = var.enable_patch_management ? 1 : 0

  name                    = "Update-AutomationAzureModulesForAccount"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = module.automation-account.automation_account_name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Default runbook that updates Azure modules"
  runbook_type            = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/microsoft/AzureAutomation-Account-Modules-Update/v2.0/Update-AutomationAzureModulesForAccount.ps1"
  }
}

# Schedule to run the update module monthly
resource "azurerm_automation_schedule" "update-modules-schedule" {
  count = var.enable_patch_management ? 1 : 0

  name                    = "update-modules-schedule"
  resource_group_name     = var.resource_group_name
  automation_account_name = module.automation-account.automation_account_name
  frequency               = "Month"
  interval                = 1
  timezone                = var.patch_mgmt_timezone
  start_time              = timeadd(timestamp(), "3h")
  description             = "Monthly schedule to update Azure modules in automation account"
  month_days              = ["1"]
}

# Job schedule to link schedule to runbook and give expected parameters
resource "azurerm_automation_job_schedule" "update-modules-job" {
  count = var.enable_patch_management ? 1 : 0

  resource_group_name     = var.resource_group_name
  automation_account_name = module.automation-account.automation_account_name
  schedule_name           = azurerm_automation_schedule.update-modules-schedule[0].name
  runbook_name            = azurerm_automation_runbook.default-update-modules-runbook[0].name

  parameters = {
    resourcegroupname     = var.resource_group_name
    automationaccountname = module.automation-account.automation_account_name
    azuremoduleclass      = "Az"
  }
}

