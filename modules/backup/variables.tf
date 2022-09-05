###############################
# Global variables
###############################

variable "client_name" {
  description = "Client name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "stack" {
  description = "Stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group the resources will belong to"
  type        = string
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

###############################
# Azure Recovery Vault variables
###############################

variable "recovery_vault_sku" {
  description = "Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`."
  type        = string
  default     = "Standard"
}

variable "recovery_vault_storage_mode_type" {
  description = "The storage type of the Recovery Services Vault. Possible values are `GeoRedundant`, `LocallyRedundant` and `ZoneRedundant`. Defaults to `GeoRedundant`."
  type        = string
  default     = "GeoRedundant"
}

variable "recovery_vault_cross_region_restore_enabled" {
  description = "Is cross region restore enabled for this Vault? Only can be `true`, when `storage_mode_type` is `GeoRedundant`. Defaults to `false`."
  type        = bool
  default     = true
}

variable "recovery_vault_soft_delete_enabled" {
  description = "Is soft delete enable for this Vault? Defaults to `true`."
  type        = bool
  default     = true
}

variable "recovery_vault_identity_type" {
  description = "Azure Recovery Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}

variable "vm_backup_policy_timezone" {
  description = "Specifies the timezone for VM backup schedules. Defaults to `UTC`."
  type        = string
  default     = "UTC"
}

variable "vm_backup_policy_time" {
  description = "The time of day to perform the VM backup in 24hour format."
  type        = string
  default     = "04:00"
}

variable "vm_backup_policy_frequency" {
  description = "Specifies the frequency for VM backup schedules. Must be either `Daily` or `Weekly`."
  type        = string
  default     = "Daily"
}

variable "vm_backup_daily_policy_retention" {
  description = "The number of daily VM backups to keep. Must be between 7 and 9999."
  type        = number
  default     = 30
}

variable "vm_backup_weekly" {
  description = "Map to configure the weekly VM backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_weekly"
  type        = any
  default     = {}
}

variable "vm_backup_monthly" {
  description = "Map to configure the monthly VM backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_monthly"
  type        = any
  default     = {}
}

variable "vm_backup_yearly" {
  description = "Map to configure the yearly VM backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_yearly"
  type        = any
  default     = {}
}

variable "file_share_backup_policy_timezone" {
  description = "Specifies the timezone for file share backup schedules. Defaults to `UTC`."
  type        = string
  default     = "UTC"
}

variable "file_share_backup_policy_time" {
  description = "The time of day to perform the file share backup in 24hour format."
  type        = string
  default     = "04:00"
}

variable "file_share_backup_daily_policy_retention" {
  description = "The number of daily file share backups to keep. Must be between 7 and 9999."
  type        = number
  default     = 30
}

variable "file_share_backup_policy_frequency" {
  description = "Specifies the frequency for file_share backup schedules. Must be either `Daily` or `Weekly`."
  type        = string
  default     = "Daily"
}

variable "file_share_backup_weekly" {
  description = "Map to configure the weekly File Share backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_weekly"
  type        = any
  default     = {}
}

variable "file_share_backup_monthly" {
  description = "Map to configure the monthly File Share backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_monthly"
  type        = any
  default     = {}
}

variable "file_share_backup_yearly" {
  description = "Map to configure the yearly File Share backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_yearly"
  type        = any
  default     = {}
}
