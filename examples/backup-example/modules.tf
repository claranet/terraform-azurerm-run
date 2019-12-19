module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "2.0.1"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "2.1.0"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "az-vm-backup" {
  source  = "claranet/run-iaas/azurerm//modules/backup"
  version = "2.0.0"

  location       = module.az-region.location
  location_short = module.az-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  extra_tags = {
    foo = "bar"
  }
}
