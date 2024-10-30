###############################
# Log Management outputs
###############################
output "logs_resource_group_name" {
  description = "Resource Group of the logs resources."
  value       = module.logs.logs_resource_group_name
}

output "log_analytics_workspace_id" {
  description = "The Log Analytics Workspace ID."
  value       = module.logs.id
}

output "log_analytics_workspace_name" {
  description = "The Log Analytics Workspace name."
  value       = module.logs.name
}

output "log_analytics_workspace_location" {
  description = "The Log Analytics Workspace location."
  value       = module.logs.log_analytics_workspace_location
}

output "log_analytics_workspace_guid" {
  description = "The Log Analytics Workspace GUID."
  value       = module.logs.log_analytics_workspace_guid
}

output "log_analytics_workspace_primary_key" {
  description = "The primary shared key for the Log Analytics Workspace."
  value       = module.logs.log_analytics_workspace_primary_key
  sensitive   = true
}

output "log_analytics_workspace_secondary_key" {
  description = "The secondary shared key for the Log Analytics Workspace."
  value       = module.logs.log_analytics_workspace_secondary_key
  sensitive   = true
}

output "logs_storage_account_id" {
  description = "ID of the logs Storage Account."
  value       = module.logs.storage_account_id
}

output "logs_storage_account_name" {
  description = "Name of the logs Storage Account."
  value       = module.logs.storage_account_name
}

output "logs_storage_account_primary_connection_string" {
  description = "Primary connection string of the logs Storage Account."
  value       = module.logs.storage_account_primary_connection_string
  sensitive   = true
}

output "logs_storage_account_primary_access_key" {
  description = "Primary connection string of the logs Storage Account."
  value       = module.logs.storage_account_primary_access_key
  sensitive   = true
}

output "logs_storage_account_secondary_connection_string" {
  description = "Secondary connection string of the logs Storage Account."
  value       = module.logs.storage_account_secondary_connection_string
  sensitive   = true
}

output "logs_storage_account_secondary_access_key" {
  description = "Secondary connection string of the logs Storage Account."
  value       = module.logs.storage_account_secondary_access_key
  sensitive   = true
}

output "logs_storage_account_archived_logs_fileshare_name" {
  description = "Name of the file share in which externalized logs are stored."
  value       = module.logs.storage_account_archived_logs_fileshare_name
}

output "module_logs" {
  description = "Module logs outputs."
  value       = one(module.logs[*])
}
