terraform {
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azurecaf = {
      source  = "claranet/azurecaf"
      version = ">= 1.2.28"
    }
  }
}
