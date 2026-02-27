###############################
# Azure Update Management Center outputs
###############################

output "maintenance_configurations" {
  description = "Update Center Maintenance Configurations information."
  value       = one(module.update_management_center[*].resource)
}

# Deprecated: Use `module_update_management_center` instead.
output "module_maintenance_configurations" {
  description = "Module maintenance configurations outputs. Deprecated, use `module_update_management_center` instead."
  value       = one(module.update_management_center[*])
}

output "module_update_management_center" {
  description = "Module Update Management Center outputs."
  value       = one(module.update_management_center[*])
}
