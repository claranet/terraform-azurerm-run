terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    # tflint-ignore: terraform_unused_required_providers
    azurecaf = {
      source  = "claranet/azurecaf"
      version = "~> 1.3.0"
    }
  }
}
