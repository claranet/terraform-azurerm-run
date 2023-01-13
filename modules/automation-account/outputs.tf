##################################
# Azure Automation Account outputs
##################################
output "automation_account_name" {
  description = "Azure Automation Account name"
  value       = azurerm_automation_account.automation_account.name
}

output "automation_account_id" {
  description = "Azure Automation Account ID"
  value       = azurerm_automation_account.automation_account.id
}

output "automation_account_dsc_primary_access_key" {
  description = "Azure Automation Account DSC Primary Acess Key"
  value       = azurerm_automation_account.automation_account.dsc_primary_access_key
  sensitive   = true
}

output "automation_account_dsc_secondary_access_key" {
  description = "Azure Automation Account DSC Secondary Acess Key"
  value       = azurerm_automation_account.automation_account.dsc_secondary_access_key
  sensitive   = true
}

output "automation_account_dsc_server_endpoint" {
  description = "Azure Automation Account DSC Server Endpoint"
  value       = azurerm_automation_account.automation_account.dsc_server_endpoint
}

output "automation_account_identity" {
  description = "Identity block with principal ID and tenant ID"
  value       = azurerm_automation_account.automation_account.identity
}
