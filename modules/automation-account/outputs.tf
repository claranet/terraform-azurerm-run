##################################
# Azure Automation Account outputs
##################################
output "automation_account_name" {
  description = "Azure Automation Account name"
  value       = azurerm_automation_account.automation-account.name
}

output "automation_account_id" {
  description = "Azure Automation Account name"
  value       = azurerm_automation_account.automation-account.id
}