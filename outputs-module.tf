output "terraform_module" {
  description = "Information about this Terraform module."
  value = {
    name       = "run"
    provider   = "azurerm"
    maintainer = "claranet"
  }
}
