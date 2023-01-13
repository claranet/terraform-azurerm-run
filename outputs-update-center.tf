###############################
# Azure Update Manamagent Center outputs
###############################

output "maintenance_configurations" {
  description = "Maintenance Configurations informations."
  value       = try(module.update_management_center["enabled"].maintenance_configurations, null)
}
