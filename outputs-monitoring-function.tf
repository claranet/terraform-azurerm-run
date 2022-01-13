###############################
# Monitoring Function outputs
###############################
output "monitoring_function_app_service_plan_id" {
  description = "Id of the created App Service Plan"
  value       = try(module.monitoring_function[0].app_service_plan_id, null)
}

output "monitoring_function_app_service_plan_name" {
  description = "Name of the created App Service Plan"
  value       = try(module.monitoring_function[0].app_service_plan_name, null)
}

output "monitoring_function_storage_account_id" {
  description = "Id of the associated Storage Account, empty if connection string provided"
  value       = try(module.monitoring_function[0].storage_account_id, null)
}

output "monitoring_function_storage_account_name" {
  description = "Name of the associated Storage Account, empty if connection string provided"
  value       = try(module.monitoring_function[0].storage_account_name, null)
}

output "monitoring_function_storage_queries_table_name" {
  description = "Name of the table in the Storage Account, empty if connection string provided"
  value       = try(module.monitoring_function[0].storage_queries_table_name, null)
}

output "monitoring_function_storage_account_primary_connection_string" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value       = try(module.monitoring_function[0].storage_account_primary_connection_string, null)
  sensitive   = true
}

output "monitoring_function_storage_account_primary_access_key" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value       = try(module.monitoring_function[0].storage_account_primary_access_key, null)
  sensitive   = true
}

output "monitoring_function_storage_account_secondary_connection_string" {
  description = "Secondary connection string of the associated Storage Account, empty if connection string provided"
  value       = try(module.monitoring_function[0].storage_account_secondary_connection_string, null)
  sensitive   = true
}

output "monitoring_function_storage_account_secondary_access_key" {
  description = "Secondary connection string of the associated Storage Account, empty if connection string provided"
  value       = try(module.monitoring_function[0].storage_account_secondary_access_key, null)
  sensitive   = true
}

output "monitoring_function_application_insights_id" {
  description = "Id of the associated Application Insights"
  value       = try(module.monitoring_function[0].application_insights_id, null)
}

output "monitoring_function_application_insights_name" {
  description = "Name of the associated Application Insights"
  value       = try(module.monitoring_function[0].application_insights_name, null)
}

output "monitoring_function_application_insights_app_id" {
  description = "App id of the associated Application Insights"
  value       = try(module.monitoring_function[0].application_insights_app_id, null)
}

output "monitoring_function_application_insights_instrumentation_key" {
  description = "Instrumentation key of the associated Application Insights"
  value       = try(module.monitoring_function[0].application_insights_instrumentation_key, null)
  sensitive   = true
}

output "monitoring_function_application_insights_application_type" {
  description = "Application Type of the associated Application Insights"
  value       = try(module.monitoring_function[0].application_insights_application_type, null)
}

output "monitoring_function_function_app_id" {
  description = "Id of the created Function App"
  value       = try(module.monitoring_function[0].function_app_id, null)
}

output "monitoring_function_function_app_name" {
  description = "Name of the created Function App"
  value       = try(module.monitoring_function[0].function_app_name, null)
}

output "monitoring_function_function_app_outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App"
  value       = try(module.monitoring_function[0].function_app_outbound_ip_addresses, null)
}

output "monitoring_function_function_app_connection_string" {
  description = "Connection string of the created Function App"
  value       = try(module.monitoring_function[0].function_app_connection_string, null)
  sensitive   = true
}

output "monitoring_function_function_app_identity" {
  description = "Identity block output of the Function App"
  value       = try(module.monitoring_function[0].function_app_identity, null)
}
