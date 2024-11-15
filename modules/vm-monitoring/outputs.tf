output "id" {
  description = "ID of the Azure Monitor Data Collection Rule."
  value       = azurerm_monitor_data_collection_rule.main.id
}

output "name" {
  description = "Name of the Azure Monitor Data Collection Rule."
  value       = azurerm_monitor_data_collection_rule.main.name
}

output "resource" {
  description = "Azure Monitor Data Collection Rule resource object."
  value       = azurerm_monitor_data_collection_rule.main
}
