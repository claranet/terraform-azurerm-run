terraform {
  required_version = "~>0.12.15"

  required_providers {
    azurerm = "~> 1.36"
  }
}

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id

  skip_provider_registration = false
}
