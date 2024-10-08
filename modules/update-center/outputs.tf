output "ids" {
  description = "Maintenance Configuration resources IDs."
  value       = azurerm_maintenance_configuration.main[*].id
}

output "resource" {
  description = "Maintenance Configurations resource object."
  value       = azurerm_maintenance_configuration.main
}

output "resource_management_group_policy_assignment" {
  description = "Management Group Policy Assignment resource object."
  value       = merge(azurerm_management_group_policy_assignment.main_linux, azurerm_management_group_policy_assignment.main_windows)
}

output "resource_subscription_policy_assignment" {
  description = "Subscription Policy Assignment resource object."
  value       = merge(azurerm_subscription_policy_assignment.main_linux, azurerm_subscription_policy_assignment.main_windows)
}

output "resource_group_policy_assignment" {
  description = "Resource Group Policy Assignment resource object."
  value       = merge(azurerm_resource_group_policy_assignment.main_linux, azurerm_resource_group_policy_assignment.main_windows)
}

output "resource_virtual_machine_policy_assignment" {
  description = "Virtual Machine Policy Assignment resource object."
  value       = merge(azurerm_resource_policy_assignment.main_linux, azurerm_resource_policy_assignment.main_windows)
}