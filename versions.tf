terraform {
  required_version = ">= 0.13"
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.57"
    }
    # tflint-ignore: terraform_unused_required_providers
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.1"
    }
  }
}
