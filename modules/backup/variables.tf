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

variable "name_prefix" {
  description = "Name prefix for all resources generated name"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

###############################
# Azure Recovery Vault variables
###############################
variable "recovery_vault_custom_name" {
  description = "Azure Recovery Vault custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "recovery_vault_sku" {
  description = "Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`."
  type        = string
  default     = "Standard"
}

variable "vm_backup_policy_custom_name" {
  description = "Azure Backup - VM backup policy custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
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

variable "vm_backup_policy_retention" {
  description = "The number of daily VM backups to keep. Must be between 1 and 9999."
  type        = number
  default     = 30
}

variable "file_share_backup_policy_custom_name" {
  description = "Azure Backup - File share backup policy custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
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

variable "file_share_backup_policy_retention" {
  description = "The number of daily file share backups to keep. Must be between 1 and 9999."
  type        = number
  default     = 30
}

variable "log_retention_in_days" {
  description = "Retention time in days for the logs"
  type        = number
  default     = 365
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID where the logs are sent"
  type        = string
  default     = null
}

variable "log_storage_account_id" {
  description = "Storage account ID where the logs are sent"
  type        = string
  default     = null
}

variable "log_eventhub_authorization_rule_id" {
  description = "Event hub authorization rule ID where the logs are sent"
  type        = string
  default     = null
}

variable "log_categories" {
  type        = list
  default     = null
  description = <<EOD
List of log categories. By default this module use a data source to retrieve them:
`["CoreAzureBackup", "AddonAzureBackupJobs", "AddonAzureBackupAlerts", "AddonAzureBackupPolicy", "AddonAzureBackupStorage", "AddonAzureBackupProtectedInstance"]`
EOD
}

variable "log_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable logs configuration in diagnostics settings"
}

variable "diagnostics_settings_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable diagnostics settings on the recovery vault"
}
