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

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

module "automation_account" {
  source  = "claranet/run-iaas/azurerm//modules/automation-account"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
  client_name         = var.client_name
  stack               = var.stack
  environment         = var.environment

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]

  extra_tags = {
    foo = "bar"
  }
}

resource "time_offset" "update_template" {
  offset_hours = 4
}

locals {
  update_template_date = format("%s-%02d-%02d", "${time_offset.update_template.year}", "${time_offset.update_template.month}", "${time_offset.update_template.day + 1}")
}

module "update_management" {
  source  = "claranet/run-iaas/azurerm//modules/update-management"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  automation_account_name    = module.automation_account.automation_account_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  update_management_os_list        = ["Linux"]
  update_management_scope          = [module.rg.resource_group_id]
  update_management_tags_filtering = { update_color = ["blue"] }
  update_management_schedule = [{
    startTime  = "${local.update_template_date}T02:00:00+00:00"
    expiryTime = "9999-12-31T23:59:00+00:00"
    isEnabled  = true
    interval   = 1
    frequency  = "Month"
    timeZone   = "UTC"
    advancedSchedule = {
      monthlyOccurrences = [
        {
          occurrence = 3
          day        = "Monday"
        }
      ]
    }
  }]
}
