output "maintenance_configurations" {
  description = "Maintenance Configurations informations."
  value       = try(azapi_resource.maintenance_configurations, {})
}

