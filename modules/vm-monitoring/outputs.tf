output "data_collection_rule_id" {
  description = "ID of the Azure Monitor Data Collection Rule."
  value       = azurerm_monitor_data_collection_rule.dcr.id
}

output "data_collection_rule_name" {
  description = "Name of the Azure Monitor Data Collection Rule."
  value       = azurerm_monitor_data_collection_rule.dcr.name
}

output "data_collection_rule" {
  description = "Azure Monitor Data Collection Rule object."
  value       = azurerm_monitor_data_collection_rule.dcr
}
