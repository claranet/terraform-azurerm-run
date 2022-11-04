terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.2"
    }
    # tflint-ignore: terraform_unused_required_providers
    azapi = {
      source  = "azure/azapi"
      version = "~> 0.1"
    }
  }
}

provider "azurerm" {
  features {}
}
