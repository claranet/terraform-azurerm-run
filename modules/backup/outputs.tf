###############################
# Azure Backup outputs
###############################
output "recovery_vault_name" {
  description = "Azure Recovery Services Vault name."
  value       = one(azurerm_recovery_services_vault.main[*].name)
}

output "recovery_vault_id" {
  description = "Azure Recovery Services Vault ID."
  value       = one(azurerm_recovery_services_vault.main[*].id)
}

output "recovery_vault_identity" {
  description = "Azure Recovery Services Vault identity."
  value       = try(azurerm_recovery_services_vault.main[*].identity[0], null)
}

output "resource_recovery_vault" {
  description = "Resource recovery vault."
  value       = one(azurerm_recovery_services_vault.main[*])
}

output "backup_vault_name" {
  description = "Azure Backup Vault name."
  value       = one(azurerm_data_protection_backup_vault.main[*].name)
}

output "backup_vault_id" {
  description = "Azure Backup Vault ID."
  value       = one(azurerm_data_protection_backup_vault.main[*].id)
}

output "backup_vault_identity" {
  description = "Azure Backup Services Vault identity."
  value       = try(azurerm_data_protection_backup_vault.main[*].identity[0], null)
}

output "resource_backup_vault" {
  description = "Resource backup vault."
  value       = one(azurerm_data_protection_backup_vault.main[*])
}

output "vm_backup_policy_name" {
  description = "VM Backup policy name."
  value       = one(azurerm_backup_policy_vm.main[*].name)
}

output "vm_backup_policy_id" {
  description = "VM Backup policy ID."
  value       = one(azurerm_backup_policy_vm.main[*].id)
}

output "resource_vm_backup_policy" {
  description = "VM Backup policy resource."
  value       = one(azurerm_backup_policy_vm.main[*])

}
output "file_share_backup_policy_name" {
  description = "File share Backup policy name."
  value       = one(azurerm_backup_policy_file_share.main[*].name)
}

output "file_share_backup_policy_id" {
  description = "File share Backup policy ID."
  value       = one(azurerm_backup_policy_file_share.main[*].id)
}

output "resource_file_share_backup_policy" {
  description = "File share Backup policy resource."
  value       = one(azurerm_backup_policy_file_share.main[*])
}

output "postgresql_backup_policy_id" {
  description = "PostgreSQL Backup policy ID."
  value       = one(azurerm_data_protection_backup_policy_postgresql_flexible_server.main[*].id)
}

output "resource_postgresql_backup_policy" {
  description = "PostgreSQL Backup policy resource."
  value       = one(azurerm_data_protection_backup_policy_postgresql_flexible_server.main[*])
}

output "managed_disk_backup_policy_id" {
  description = "Managed disk Backup policy ID."
  value       = one(azurerm_data_protection_backup_policy_disk.main[*].id)
}

output "resource_managed_disk_backup_policy" {
  description = "Managed disk Backup policy resource."
  value       = one(azurerm_data_protection_backup_policy_disk.main[*])
}

output "storage_blob_backup_policy_id" {
  description = "Storage blob Backup policy ID."
  value       = one(azurerm_data_protection_backup_policy_blob_storage.main[*].id)
}

output "resource_storage_blob_backup_policy" {
  description = "Storage blob Backup policy resource."
  value       = one(azurerm_data_protection_backup_policy_blob_storage.main[*])
}
