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

module "automation-account" {
  source  = "claranet/run-iaas/azurerm//modules/automation-account"
  version = "x.x.x"

  location            = module.azure-region.location
  resource_group_name = module.rg.resource_group_name
  client_name         = var.client_name
  stack               = var.stack
  environment         = var.environment

  extra_tags = {
    foo = "bar"
  }
}
