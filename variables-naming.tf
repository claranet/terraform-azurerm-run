# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. `*custom_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Automation Account
variable "custom_automation_account_name" {
  description = "Automation account custom name."
  type        = string
  default     = ""
}

# Backup
variable "recovery_vault_custom_name" {
  description = "Azure Recovery Vault custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "vm_backup_policy_custom_name" {
  description = "Azure Backup - VM backup policy custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "file_share_backup_policy_custom_name" {
  description = "Azure Backup - File share backup policy custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

# Update Mgmnt
variable "update_management_name_prefix" {
  description = "Name prefix to apply on Update Management resources."
  type        = string
  default     = null
}

variable "linux_update_management_config_name" {
  description = "Custom configuration name for Linux Update management."
  type        = string
  default     = "Standard Linux Update Schedule"
}

variable "windows_update_management_configuration_name" {
  description = "Custom configuration name for Windows Update management."
  type        = string
  default     = "Standard Windows Update Schedule"
}

# VM Monitoring
variable "dcr_custom_name" {
  description = "VM Monitoring - Data Collection rule custom name."
  type        = string
  default     = ""
}
