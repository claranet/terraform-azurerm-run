locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  vault_name             = coalesce(var.recovery_vault_custom_name, azurecaf_name.vault.result)
  vm_policy_name         = coalesce(var.vm_backup_policy_custom_name, "${azurecaf_name.vault.result}-vm-backup-policy")
  file_share_policy_name = coalesce(var.file_share_backup_policy_custom_name, "${azurecaf_name.vault.result}-fileshare-backup-policy")
}
