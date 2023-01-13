###############################
# Azure Backup outputs
###############################
output "recovery_vault_name" {
  description = "Azure Recovery Services Vault name"
  value       = one(azurerm_recovery_services_vault.vault[*].name)
}

output "recovery_vault_id" {
  description = "Azure Recovery Services Vault ID"
  value       = one(azurerm_recovery_services_vault.vault[*].id)
}

output "vm_backup_policy_name" {
  description = "VM Backup policy name"
  value       = one(azurerm_backup_policy_vm.vm_backup_policy[*].name)
}

output "vm_backup_policy_id" {
  description = "VM Backup policy ID"
  value       = one(azurerm_backup_policy_vm.vm_backup_policy[*].id)
}

output "file_share_backup_policy_name" {
  description = "File share Backup policy name"
  value       = one(azurerm_backup_policy_file_share.file_share_backup_policy[*].name)
}

output "file_share_backup_policy_id" {
  description = "File share Backup policy ID"
  value       = one(azurerm_backup_policy_file_share.file_share_backup_policy[*].id)
}
