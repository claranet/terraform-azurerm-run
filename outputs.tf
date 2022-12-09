###############################
# Azure Data Collection Rule outputs
###############################
output "data_collection_rule_id" {
  description = "ID of the Azure Monitor Data Collection Rule."
  value       = one(module.vm_monitoring[*].data_collection_rule_id)
}

output "data_collection_rule_name" {
  description = "Name of the Azure Monitor Data Collection Rule."
  value       = one(module.vm_monitoring[*].data_collection_rule_name)
}

output "data_collection_rule" {
  description = "Azure Monitor Data Collection Rule object."
  value       = one(module.vm_monitoring[*].data_collection_rule)
}

###############################
# Azure Update Manamagent Center outputs
###############################

output "maintenance_configurations" {
  description = "Maintenance Configurations informations."
  value       = try(module.update_management_center["enabled"].maintenance_configurations, null)
}
