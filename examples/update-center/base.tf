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

module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  location       = module.azure_region.location
  location_short = module.azure_region.location_short

  vnet_cidr = ["10.10.10.0/24"]
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  resource_group_name = module.rg.name
  location_short      = module.azure_region.location_short
  subnet_cidr_list = [
    "10.10.10.0/27"
  ]
  virtual_network_name = module.vnet.name
}


module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  tenant_id = var.azure_tenant_id

  monitoring_function_enabled      = false
  monitoring_function_splunk_token = ""

  update_center_enabled = false

  keyvault_network_acls = {
    bypass   = "AzureServices"
    ip_rules = []
  }

  keyvault_admin_objects_ids = []

  keyvault_enabled_for_deployment = true
}

