###############################
# Azure Update Manamagent Center outputs
###############################

output "maintenance_configurations" {
  description = "Update Center Maintenance Configurations information."
  value       = one(module.update_management_center[*].maintenance_configurations)
}

output "module_maintenance_configurations" {
  description = "Module maintenance configurations outputs."
  value       = one(module.update_management_center[*])
}