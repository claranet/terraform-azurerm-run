##################################
# Azure Automation Account outputs
##################################
output "name" {
  description = "Azure Automation Account name."
  value       = azurerm_automation_account.main.name
}

output "id" {
  description = "Azure Automation Account ID."
  value       = azurerm_automation_account.main.id
}

output "dsc_primary_access_key" {
  description = "Azure Automation Account DSC primary access key."
  value       = azurerm_automation_account.main.dsc_primary_access_key
  sensitive   = true
}

output "dsc_secondary_access_key" {
  description = "Azure Automation Account DSC secondary access key."
  value       = azurerm_automation_account.main.dsc_secondary_access_key
  sensitive   = true
}

output "dsc_server_endpoint" {
  description = "Azure Automation Account DSC server endpoint."
  value       = azurerm_automation_account.main.dsc_server_endpoint
}

output "identity" {
  description = "Identity block with principal ID and tenant ID."
  value       = azurerm_automation_account.main.identity
}

output "resource" {
  description = "Automation account resource object."
  value       = azurerm_automation_account.main
}

output "module_diagnostics" {
  description = "Diagnostic settings module output."
  value       = module.diagnostics
}

output "resource_log_analytics_linked_service" {
  description = "Log Analytics linked service resource object."
  value       = azurerm_log_analytics_linked_service.main
}
