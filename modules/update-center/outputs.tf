output "maintenance_configurations" {
  description = "Maintenance Configurations information."
  value       = try(azurerm_maintenance_configuration.maintenance_configurations, {})
}
