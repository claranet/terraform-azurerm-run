terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114"
    }
    # tflint-ignore: terraform_unused_required_providers
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2, >= 1.2.22"
    }
    # tflint-ignore: terraform_unused_required_providers
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}
