###############################
# Azure Backup outputs
###############################
output "recovery_vault_name" {
  description = "Azure Recovery Services Vault name"
  value       = module.azure-backup.recovery_vault_name
}

output "recovery_vault_id" {
  description = "Azure Recovery Services Vault ID"
  value       = module.azure-backup.recovery_vault_id
}

output "vm_backup_policy_name" {
  description = "VM Backup policy name"
  value       = module.azure-backup.vm_backup_policy_name
}

output "vm_backup_policy_id" {
  description = "VM Backup policy ID"
  value       = module.azure-backup.vm_backup_policy_id
}

output "file_share_backup_policy_name" {
  description = "File share Backup policy name"
  value       = module.azure-backup.file_share_backup_policy_name
}

output "file_share_backup_policy_id" {
  description = "File share Backup policy ID"
  value       = module.azure-backup.file_share_backup_policy_id
}
