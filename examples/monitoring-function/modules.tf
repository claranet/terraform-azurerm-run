module "monitoring" {
  source  = "claranet/run/azurerm//modules/monitoring-function"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  log_analytics_workspace_guid = module.logs.log_analytics_workspace_guid

  application_insights_log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  splunk_token = "xxxxxx"

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]

  extra_tags = {
    foo = "bar"
  }
}
