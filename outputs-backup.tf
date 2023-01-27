###############################
# Azure Backup outputs
###############################
output "recovery_vault_name" {
  description = "Azure Recovery Services Vault name"
  value       = one(module.backup[*].recovery_vault_name)
}

output "recovery_vault_id" {
  description = "Azure Recovery Services Vault ID"
  value       = one(module.backup[*].recovery_vault_id)
}

output "recovery_vault_identity" {
  description = "Azure Recovery Services Vault identity."
  value       = one(module.backup[*].recovery_vault_identity)
}

output "backup_vault_name" {
  description = "Azure Backup Vault name"
  value       = one(module.backup[*].backup_vault_name)
}

output "backup_vault_id" {
  description = "Azure Backup Vault ID"
  value       = one(module.backup[*].backup_vault_id)
}

output "backup_vault_identity" {
  description = "Azure Backup Services Vault identity."
  value       = one(module.backup[*].backup_vault_identity)
}

output "vm_backup_policy_name" {
  description = "VM Backup policy name"
  value       = one(module.backup[*].vm_backup_policy_name)
}

output "vm_backup_policy_id" {
  description = "VM Backup policy ID"
  value       = one(module.backup[*].vm_backup_policy_id)
}

output "file_share_backup_policy_name" {
  description = "File share Backup policy name"
  value       = one(module.backup[*].file_share_backup_policy_name)
}

output "file_share_backup_policy_id" {
  description = "File share Backup policy ID"
  value       = one(module.backup[*].file_share_backup_policy_id)
}

output "postgresql_backup_policy_id" {
  description = "PostgreSQL Backup policy ID"
  value       = one(module.backup[*].postgresql_backup_policy_id)
}

output "managed_disk_backup_policy_id" {
  description = "Managed disk Backup policy ID"
  value       = one(module.backup[*].managed_disk_backup_policy_id)
}

output "storage_blob_backup_policy_id" {
  description = "Storage blob Backup policy ID"
  value       = one(module.backup[*].storage_blob_backup_policy_id)
}
