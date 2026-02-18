###############################
# Global variables
###############################

variable "client_name" {
  description = "Client name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "stack" {
  description = "Stack name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to which the resources will belong."
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
# Azure Backup flags
###############################

variable "backup_vm_enabled" {
  description = "Whether the Virtual Machines backup is enabled."
  type        = bool
  default     = true
}

variable "backup_file_share_enabled" {
  description = "Whether the File Share backup is enabled."
  type        = bool
  default     = true
}

variable "backup_postgresql_enabled" {
  description = "Whether the PostgreSQL backup is enabled."
  type        = bool
  default     = true
}

variable "backup_storage_blob_enabled" {
  description = "Whether the Storage blob backup is enabled."
  type        = bool
  default     = true
}

variable "backup_managed_disk_enabled" {
  description = "Whether the Managed Disk backup is enabled."
  type        = bool
  default     = true
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
  description = "Is cross region restore enabled for this Vault? Can only be `true`, when `storage_mode_type` is `GeoRedundant`."
  type        = bool
  default     = true
}

variable "recovery_vault_soft_delete_enabled" {
  description = "Is soft delete enable for this Vault? Defaults to `true`."
  type        = bool
  default     = true
}

variable "recovery_vault_immutability" {
  description = "Immutability setting of the Vault, possible values are `Locked`, `Unlocked` and `Disabled`. Defaults to `Unlocked`."
  type        = string
  default     = "Unlocked"
  nullable    = false
}

variable "recovery_vault_identity_type" {
  description = "Azure Recovery Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}

variable "recovery_vault_alerts_for_all_job_failures_enabled" {
  description = "Enabling/Disabling built-in Azure Monitor alerts for security scenarios and job failure scenarios. Defaults to true."
  type        = bool
  default     = true
}

variable "recovery_vault_alerts_for_critical_operation_failures_enabled" {
  description = "Enabling/Disabling alerts from the older (classic alerts) solution. Defaults to true. More details could be found [here](https://learn.microsoft.com/en-us/azure/backup/monitoring-and-alerts-overview)."
  type        = bool
  default     = true
}

variable "recovery_vault_public_network_access_enabled" {
  description = "Whether public network access is allowed for this Recovery Services Vault. Defaults to `true`."
  type        = bool
  default     = true
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

variable "vm_backup_policy_type" {
  description = "Type of the Backup Policy. Possible values are `V1` and `V2` where `V2` stands for the Enhanced Policy. Defaults to `V1`. Changing this forces a new resource to be created."
  type        = string
  default     = "V1"
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

variable "vm_backup_weekly_retention" {
  description = "Map to configure the weekly VM backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_weekly)."
  type = object({
    count    = number,
    weekdays = list(string),
  })
  default = null
}

variable "vm_backup_monthly_retention" {
  description = "Map to configure the monthly VM backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_monthly)."
  type = object({
    count    = number,
    weekdays = list(string),
    weeks    = list(string),
  })
  default = null
}

variable "vm_backup_yearly_retention" {
  description = "Map to configure the yearly VM backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_yearly)."
  type = object({
    count    = number,
    weekdays = list(string),
    weeks    = list(string),
    months   = list(string),
  })
  default = null
}

###############################
# File Share backup
###############################

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

variable "file_share_backup_weekly_retention" {
  description = "Map to configure the weekly File Share backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_weekly)."
  type = object({
    count    = number,
    weekdays = list(string),
  })
  default = null
}

variable "file_share_backup_monthly_retention" {
  description = "Map to configure the monthly File Share backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_monthly)."
  type = object({
    count    = number,
    weekdays = list(string),
    weeks    = list(string),
  })
  default = null
}

variable "file_share_backup_yearly_retention" {
  description = "Map to configure the yearly File Share backup policy retention according to the [provider's documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_yearly)"
  type = object({
    count    = number,
    weekdays = list(string),
    weeks    = list(string),
    months   = list(string),
  })
  default = null
}

###############################
# Azure Backup Vault variables
###############################

variable "backup_vault_datastore_type" {
  description = "Type of data store used for the Backup Vault."
  type        = string
  default     = "VaultStore"
}

variable "backup_vault_geo_redundancy_enabled" {
  description = "Whether the geo redundancy is enabled no the Backup Vault."
  type        = bool
  default     = true
}

variable "backup_vault_identity_type" {
  description = "Azure Backup Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}

###############################
# Managed disk backup
###############################

variable "managed_disk_backup_policy_time" {
  description = "The time of day to perform the Managed Disk backup in 24 hours format (eg 04:00)."
  type        = string
  default     = "04:00"
}

variable "managed_disk_backup_policy_interval_in_hours" {
  description = "The Managed Disk backup interval in hours."
  type        = string
  default     = 24
}

variable "managed_disk_backup_policy_retention_in_days" {
  description = "The number of days to keep the Managed Disk backup."
  type        = number
  default     = 30
}

variable "managed_disk_backup_daily_policy_retention_in_days" {
  description = "The number of days to keep the first daily Managed Disk backup."
  type        = number
  default     = null
}

variable "managed_disk_backup_weekly_policy_retention_in_weeks" {
  description = "The number of weeks to keep the first weekly Managed Disk backup."
  type        = number
  default     = null
}


###############################
# PostgreSQL backup
###############################

variable "postgresql_backup_policy_time" {
  description = "The time of day to perform the Postgresql backup in 24 hours format (eg 04:00)."
  type        = string
  default     = "04:00"
}

variable "postgresql_backup_policy_timezone" {
  description = "Specifies the timezone for PostgreSQL backup schedules. Defaults to `UTC`."
  type        = string
  default     = "UTC"
}

# PostgreSQL Flexible Server policy supports only weekly backups.
variable "postgresql_backup_policy_interval_in_weeks" {
  description = "The Postgresql backup interval in weeks."
  type        = string
  default     = 1
}

variable "postgresql_backup_weekly_policy_retention_in_weeks" {
  description = "The number of weeks to keep the first weekly Postgresql backup."
  type        = number
  default     = 12
  nullable    = false
  validation {
    condition = alltrue([
      var.postgresql_backup_weekly_policy_retention_in_weeks > 0,
      var.postgresql_backup_weekly_policy_retention_in_weeks < 522
    ])
    error_message = "The number of weeks to keep the first weekly Postgresql backup must be between 1 and 521."
  }
}

variable "postgresql_backup_monthly_policy_retention_in_months" {
  description = "The number of months to keep the first monthly Postgresql backup."
  type        = number
  default     = null
  validation {
    condition = var.postgresql_backup_monthly_policy_retention_in_months == null ? true : alltrue([
      var.postgresql_backup_monthly_policy_retention_in_months > 0,
      var.postgresql_backup_monthly_policy_retention_in_months < 121
    ])
    error_message = "The number of months to keep the first monthly Postgresql backup must be between 1 and 120."
  }
}


variable "postgresql_backup_yearly_policy_retention_in_years" {
  description = "The number of years to keep the first yearly Postgresql backup."
  type        = number
  default     = null
  validation {
    condition     = var.postgresql_backup_yearly_policy_retention_in_years == null ? true : var.postgresql_backup_yearly_policy_retention_in_years < 11
    error_message = "The maximum number of years to keep the first yearly Postgresql backup is 10."
  }
}

###############################
# Storage blob backup
###############################

variable "storage_blob_backup_policy_retention_in_days" {
  description = "The number of days to keep the Storage blob backup."
  type        = number
  default     = 30
}
