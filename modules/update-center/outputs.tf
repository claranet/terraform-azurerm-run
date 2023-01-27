output "maintenance_configurations" {
  description = "Maintenance Configurations information."
  value       = try(azapi_resource.maintenance_configurations, {})
}

