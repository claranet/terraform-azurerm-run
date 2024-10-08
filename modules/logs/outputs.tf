###############################
# Log Management outputs
###############################
output "logs_resource_group_name" {
  description = "Resource Group of the logs resources."
  value       = var.resource_group_name
}

output "id" {
  description = "The Log Analytics Workspace ID."
  value       = azurerm_log_analytics_workspace.main.id
}

output "name" {
  description = "The Log Analytics Workspace name."
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_location" {
  description = "The Log Analytics Workspace location."
  value       = azurerm_log_analytics_workspace.main.location
}

output "log_analytics_workspace_guid" {
  description = "The Log Analytics Workspace GUID."
  value       = azurerm_log_analytics_workspace.main.workspace_id
}

output "log_analytics_workspace_primary_key" {
  description = "The Primary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_secondary_key" {
  description = "The secondary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.main.secondary_shared_key
  sensitive   = true
}

output "storage_account_id" {
  description = "ID of the logs Storage Account."
  value       = one(module.storage[*].id)
}

output "storage_account_name" {
  description = "Name of the logs Storage Account."
  value       = one(module.storage[*].name)
}

output "storage_account_primary_connection_string" {
  description = "Primary connection string of the logs Storage Account."
  value       = one(module.storage[*].storage_account_properties.primary_connection_string)
  sensitive   = true
}

output "storage_account_primary_access_key" {
  description = "Primary connection string of the logs Storage Account."
  value       = one(module.storage[*].storage_account_properties.primary_access_key)
  sensitive   = true
}

output "storage_account_secondary_connection_string" {
  description = "Secondary connection string of the logs Storage Account."
  value       = one(module.storage[*].storage_account_properties.secondary_connection_string)
  sensitive   = true
}

output "storage_account_secondary_access_key" {
  description = "Secondary connection string of the logs Storage Account."
  value       = one(module.storage[*].storage_account_properties.secondary_access_key)
  sensitive   = true
}

output "storage_account_archived_logs_fileshare_name" {
  description = "Name of the file share in which externalized logs are stored."
  value       = one(azurerm_storage_share.main[*].name)
}

output "resource" {
  description = "Log Analytics Workspace resource object."
  value       = azurerm_log_analytics_workspace.main
}

output "module_storage_logs" {
  description = "Storage Account for logs module output."
  value       = one(module.storage[*])
}