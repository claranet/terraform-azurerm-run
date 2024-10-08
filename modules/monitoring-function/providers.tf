terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    # tflint-ignore: terraform_unused_required_providers
    azurecaf = {
      source  = "claranet/azurecaf"
      version = "~> 1.2.23"
    }
  }
}