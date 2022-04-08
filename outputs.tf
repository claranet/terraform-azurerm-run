###############################
# Azure Backup outputs
###############################
output "recovery_vault_name" {
  description = "Azure Recovery Services Vault name"
  value       = module.backup.recovery_vault_name
}

output "recovery_vault_id" {
  description = "Azure Recovery Services Vault ID"
  value       = module.backup.recovery_vault_id
}

output "vm_backup_policy_name" {
  description = "VM Backup policy name"
  value       = module.backup.vm_backup_policy_name
}

output "vm_backup_policy_id" {
  description = "VM Backup policy ID"
  value       = module.backup.vm_backup_policy_id
}

output "file_share_backup_policy_name" {
  description = "File share Backup policy name"
  value       = module.backup.file_share_backup_policy_name
}

output "file_share_backup_policy_id" {
  description = "File share Backup policy ID"
  value       = module.backup.file_share_backup_policy_id
}

###############################
# Azure Automation Account outputs
###############################
output "automation_account_name" {
  description = "Azure Automation Account name"
  value       = module.automation_account.automation_account_name
}

output "automation_account_id" {
  description = "Azure Automation Account ID"
  value       = module.automation_account.automation_account_id
}

output "automation_account_dsc_primary_access_key" {
  description = "Azure Automation Account DSC Primary Acess Key"
  value       = module.automation_account.automation_account_dsc_primary_access_key
  sensitive   = true
}

output "automation_account_dsc_secondary_access_key" {
  description = "Azure Automation Account DSC Secondary Acess Key"
  value       = module.automation_account.automation_account_dsc_secondary_access_key
  sensitive   = true
}

#output "automation_account_identity_id" {
#  description = "Identity block with principal ID"
#  value       = module.automation_account.automation_account.identity
#}


output "automation_account_dsc_server_endpoint" {
  description = "Azure Automation Account DSC Server Endpoint"
  value       = module.automation_account.automation_account_dsc_server_endpoint
}

###############################
# Azure Data Collection Rule outputs
###############################
output "data_collection_rule_id" {
  description = "Id of the Azure Monitor Data Collection Rule"
  value       = module.vm_monitoring.data_collection_rule_id
}

output "data_collection_rule_name" {
  description = "Name of the Azure Monitor Data Collection Rule"
  value       = module.vm_monitoring.data_collection_rule_name
}

output "data_collection_rule_data" {
  description = "JSON data of the Azure Monitor Data Collection Rule"
  value       = module.vm_monitoring.data_collection_rule_data
}
