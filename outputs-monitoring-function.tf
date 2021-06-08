###############################
# Monitoring Function outputs
###############################
output "monitoring_function_app_service_plan_id" {
  description = "Id of the created App Service Plan"
  value       = module.monitoring-function.app_service_plan_id
}

output "monitoring_function_app_service_plan_name" {
  description = "Name of the created App Service Plan"
  value       = module.monitoring-function.app_service_plan_name
}

output "monitoring_function_storage_account_id" {
  description = "Id of the associated Storage Account, empty if connection string provided"
  value       = module.monitoring-function.storage_account_id
}

output "monitoring_function_storage_account_name" {
  description = "Name of the associated Storage Account, empty if connection string provided"
  value       = module.monitoring-function.storage_account_name
}

output "monitoring_function_storage_account_primary_connection_string" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value       = module.monitoring-function.storage_account_primary_connection_string
  sensitive   = true
}

output "monitoring_function_storage_account_primary_access_key" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value       = module.monitoring-function.storage_account_primary_access_key
  sensitive   = true
}

output "monitoring_function_storage_account_secondary_connection_string" {
  description = "Secondary connection string of the associated Storage Account, empty if connection string provided"
  value       = module.monitoring-function.storage_account_secondary_connection_string
  sensitive   = true
}

output "monitoring_function_storage_account_secondary_access_key" {
  description = "Secondary connection string of the associated Storage Account, empty if connection string provided"
  value       = module.monitoring-function.storage_account_secondary_access_key
  sensitive   = true
}

output "monitoring_function_application_insights_id" {
  description = "Id of the associated Application Insights"
  value       = module.monitoring-function.application_insights_id
}

output "monitoring_function_application_insights_name" {
  description = "Name of the associated Application Insights"
  value       = module.monitoring-function.application_insights_name
}

output "monitoring_function_application_insights_app_id" {
  description = "App id of the associated Application Insights"
  value       = module.monitoring-function.application_insights_app_id
}

output "monitoring_function_application_insights_instrumentation_key" {
  description = "Instrumentation key of the associated Application Insights"
  value       = module.monitoring-function.application_insights_instrumentation_key
  sensitive   = true
}

output "monitoring_function_application_insights_application_type" {
  description = "Application Type of the associated Application Insights"
  value       = module.monitoring-function.application_insights_application_type
}

output "monitoring_function_function_app_id" {
  description = "Id of the created Function App"
  value       = module.monitoring-function.function_app_id
}

output "monitoring_function_function_app_name" {
  description = "Name of the created Function App"
  value       = module.monitoring-function.function_app_name
}

output "monitoring_function_function_app_outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App"
  value       = module.monitoring-function.function_app_outbound_ip_addresses
}

output "monitoring_function_function_app_connection_string" {
  description = "Connection string of the created Function App"
  value       = module.monitoring-function.function_app_connection_string
  sensitive   = true
}

output "monitoring_function_function_app_identity" {
  value       = module.monitoring-function.function_app_identity
  description = "Identity block output of the Function App"
}
