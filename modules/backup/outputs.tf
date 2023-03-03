###############################
# Azure Backup outputs
###############################
output "recovery_vault_name" {
  description = "Azure Recovery Services Vault name."
  value       = one(azurerm_recovery_services_vault.vault[*].name)
}

output "recovery_vault_id" {
  description = "Azure Recovery Services Vault ID."
  value       = one(azurerm_recovery_services_vault.vault[*].id)
}

output "recovery_vault_identity" {
  description = "Azure Recovery Services Vault identity."
  value       = try(azurerm_recovery_services_vault.vault[*].identity[0], null)
}

output "backup_vault_name" {
  description = "Azure Backup Vault name."
  value       = one(azurerm_data_protection_backup_vault.vault[*].name)
}

output "backup_vault_id" {
  description = "Azure Backup Vault ID."
  value       = one(azurerm_data_protection_backup_vault.vault[*].id)
}

output "backup_vault_identity" {
  description = "Azure Backup Services Vault identity."
  value       = try(azurerm_data_protection_backup_vault.vault[*].identity[0], null)
}

output "vm_backup_policy_name" {
  description = "VM Backup policy name"
  value       = one(azurerm_backup_policy_vm.vm_backup_policy[*].name)
}

output "vm_backup_policy_id" {
  description = "VM Backup policy ID."
  value       = one(azurerm_backup_policy_vm.vm_backup_policy[*].id)
}

output "file_share_backup_policy_name" {
  description = "File share Backup policy name."
  value       = one(azurerm_backup_policy_file_share.file_share_backup_policy[*].name)
}

output "file_share_backup_policy_id" {
  description = "File share Backup policy ID."
  value       = one(azurerm_backup_policy_file_share.file_share_backup_policy[*].id)
}

output "postgresql_backup_policy_id" {
  description = "PostgreSQL Backup policy ID."
  value       = one(azurerm_data_protection_backup_policy_postgresql.pgsql_policy[*].id)
}

output "managed_disk_backup_policy_id" {
  description = "Managed disk Backup policy ID."
  value       = one(azurerm_data_protection_backup_policy_disk.disk_policy[*].id)
}

output "storage_blob_backup_policy_id" {
  description = "Storage blob Backup policy ID."
  value       = one(azurerm_data_protection_backup_policy_blob_storage.blob_policy[*].id)
}
