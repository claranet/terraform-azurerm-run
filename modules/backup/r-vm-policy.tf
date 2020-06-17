resource "azurerm_backup_policy_vm" "vm_backup_policy" {
  name                = coalesce(var.vm_backup_policy_custom_name, local.vm_policy_default_name)
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = var.vm_backup_policy_timezone

  backup {
    frequency = "Daily"
    time      = var.vm_backup_policy_time
  }

  retention_daily {
    count = var.vm_backup_policy_retention
  }
}
