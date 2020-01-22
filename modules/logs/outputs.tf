###############################
# Log Management outputs
###############################
output "logs_resource_group_name" {
  description = "Resource Group the logs resources belongs to"
  value       = var.resource_group_name
}

output "log_analytics_workspace_id" {
  description = "The Log Analytics Workspace ID."
  value       = azurerm_log_analytics_workspace.log_workspace.id
}

output "log_analytics_workspace_name" {
  description = "The Log Analytics Workspace name."
  value       = azurerm_log_analytics_workspace.log_workspace.name
}

output "log_analytics_workspace_guid" {
  description = "The Log Analytics Workspace GUID."
  value       = azurerm_log_analytics_workspace.log_workspace.workspace_id
}

output "log_analytics_workspace_primary_key" {
  description = "The Primary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.log_workspace.primary_shared_key
}

output "log_analytics_workspace_secondary_key" {
  description = "The Secondary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.log_workspace.secondary_shared_key
}

output "log_analytics_workspace_portal_url" {
  description = "The Portal URL for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.log_workspace.portal_url
}

output "logs_storage_account_id" {
  description = "Id of the dedicated Storage Account"
  value       = azurerm_storage_account.storage_logs.id
}

output "logs_storage_account_name" {
  description = "Name of the logs Storage Account"
  value       = azurerm_storage_account.storage_logs.name
}

output "logs_storage_account_primary_connection_string" {
  description = "Primary connection string of the logs Storage Account, empty if connection string provided"
  value       = azurerm_storage_account.storage_logs.primary_connection_string
  sensitive   = true
}

output "logs_storage_account_primary_access_key" {
  description = "Primary connection string of the logs Storage Account, empty if connection string provided"
  value       = azurerm_storage_account.storage_logs.primary_access_key
  sensitive   = true
}

output "logs_storage_account_secondary_connection_string" {
  description = "Secondary connection string of the logs Storage Account, empty if connection string provided"
  value       = azurerm_storage_account.storage_logs.secondary_connection_string
  sensitive   = true
}

output "logs_storage_account_secondary_access_key" {
  description = "Secondary connection string of the logs Storage Account, empty if connection string provided"
  value       = azurerm_storage_account.storage_logs.secondary_access_key
  sensitive   = true
}

output "logs_storage_account_sas_token" {
  description = "SAS Token generated for logs access on Storage Account with full permissions on containers and objects for blob and table services."
  value       = data.external.generate_storage_sas_token.result
  sensitive   = true
}

output "logs_storage_acount_appservices_container_name" {
  description = "Name of the container in which App Services logs are stored"
  value       = azurerm_storage_container.container_webapps.name
}

