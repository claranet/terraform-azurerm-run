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

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

resource "time_offset" "update_template" {
  offset_hours = 4
}

locals {
  update_template_time = format("%02d:%02d", time_offset.update_template.hour, time_offset.update_template.minute)
  update_template_date = substr(time_offset.update_template.rfc3339, 0, 10)
}

module "run_iaas" {
  source  = "claranet/run-iaas/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name          = module.rg.resource_group_name
  log_analytics_workspace_name = module.logs.log_analytics_workspace_name

  update_management_scope = [module.rg.resource_groupe_id]
  update_management_schedule = [{
    startTime  = "${local.update_template_date}T${local.update_template_time}:00+00:00"
    expirytime = "9999-12-31T23:59:00+00:00"
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

  extra_tags = {
    foo = "bar"
  }
}
