###############################
# Azure Backup outputs
###############################
output "recovery_vault_name" {
  description = "Azure Recovery Services Vault name"
  value       = "${azurerm_recovery_services_vault.vault.name}"
}

output "recovery_vault_id" {
  description = "Azure Recovery Services Vault ID"
  value       = "${azurerm_recovery_services_vault.vault.id}"
}

output "vm_backup_policy_name" {
  description = "VM Backup policy name"
  value       = "${azurerm_recovery_services_protection_policy_vm.vm_backup_policy.name}"
}

output "vm_backup_policy_id" {
  description = "VM Backup policy ID"
  value       = "${azurerm_recovery_services_protection_policy_vm.vm_backup_policy.id}"
}
