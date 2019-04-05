# Log workspace
output "log_analytics_id" {
  description = "The Log Analytics ID."
  value       = "${azurerm_log_analytics_workspace.log-workspace.id}"
}

output "log_analytics_workspace_id" {
  description = "The Log Analytics Workspace ID."
  value       = "${azurerm_log_analytics_workspace.log-workspace.workspace_id}"
}

output "log_analytics_primary_key" {
  description = "The Primary shared key for the Log Analytics Workspace."
  value       = "${azurerm_log_analytics_workspace.log-workspace.primary_shared_key}"
}

output "log_analytics_secondary_key" {
  description = "The Secondary shared key for the Log Analytics Workspace."
  value       = "${azurerm_log_analytics_workspace.log-workspace.secondary_shared_key}"
}

output "log_analytics_portal_url" {
  description = "The Portal URL for the Log Analytics Workspace."
  value       = "${azurerm_log_analytics_workspace.log-workspace.portal_url}"
}

# Storage logs
output "storage_account_id" {
  description = "Id of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage-logs.*.id)}"
}

output "storage_account_name" {
  description = "Name of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage-logs.*.name)}"
}

output "storage_account_primary_connection_string" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage-logs.*.primary_connection_string)}"
  sensitive   = true
}

output "storage_account_primary_access_key" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage-logs.*.primary_access_key)}"
  sensitive   = true
}

output "storage_account_secondary_connection_string" {
  description = "Secondary connection string of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage-logs.*.secondary_connection_string)}"
  sensitive   = true
}

output "storage_account_secondary_access_key" {
  description = "Secondary connection string of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage-logs.*.secondary_access_key)}"
  sensitive   = true
}

output "storage_account_sas_token" {
  description = "SAS Token generated for logs access"

  #  value       = "${join("", data.azurerm_storage_account_sas.storage-logs-sas-access.*.sas)}"
  value     = "${join("", flatten(data.external.generate-storage-sas-token.*.result))}"
  sensitive = true
}
