module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  monitoring_function_splunk_token = "xxxxxx"
  monitoring_function_metrics_extra_dimensions = {
    env           = var.environment
    sfx_monitored = "true"
  }

  extra_tags = {
    foo = "bar"
  }
}
