variable "default_tags_enabled" {
  description = "Whether the default tags are enabled."
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Extra tags to add."
  type        = map(string)
  default     = {}
}

variable "keyvault_extra_tags" {
  description = "Extra tags to add to the Key Vault"
  type        = map(string)
  default     = {}
}

variable "automation_account_extra_tags" {
  description = "Extra tags to add to Automation Account."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_extra_tags" {
  description = "Extra tags to add to the Log Analytics Workspace"
  type        = map(string)
  default     = {}
}

variable "logs_storage_account_extra_tags" {
  description = "Extra tags to add to the logs Storage Account"
  type        = map(string)
  default     = {}
}

variable "monitoring_function_extra_tags" {
  description = "Monitoring function extra tags to add"
  type        = map(string)
  default     = {}
}

variable "recovery_vault_extra_tags" {
  description = "Extra tags to add to Recovery Vault."
  type        = map(string)
  default     = {}
}

variable "backup_vault_extra_tags" {
  description = "Extra tags to add to Backup Vault."
  type        = map(string)
  default     = {}
}
