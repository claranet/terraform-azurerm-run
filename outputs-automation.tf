###############################
# Azure Automation Account outputs
###############################
output "automation_account_name" {
  description = "Azure Automation Account name."
  value       = one(module.automation_account[*].name)
}

output "automation_account_id" {
  description = "Azure Automation Account ID."
  value       = one(module.automation_account[*].id)
}

output "automation_account_dsc_primary_access_key" {
  description = "Azure Automation Account DSC primary access key."
  value       = one(module.automation_account[*].dsc_primary_access_key)
  sensitive   = true
}

output "automation_account_dsc_secondary_access_key" {
  description = "Azure Automation Account DSC secondary access key."
  value       = one(module.automation_account[*].dsc_secondary_access_key)
  sensitive   = true
}

output "automation_account_dsc_server_endpoint" {
  description = "Azure Automation Account DSC server endpoint."
  value       = one(module.automation_account[*].dsc_server_endpoint)
}

output "automation_account_identity" {
  description = "Identity block with principal ID and tenant ID."
  value       = one(module.automation_account[*].identity)
}

output "module_automation" {
  description = "Module automation outputs."
  value       = one(module.automation_account[*])
}
