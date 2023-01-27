# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. `recovery_vault_custom_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "recovery_vault_custom_name" {
  description = "Azure Recovery Vault custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "backup_vault_custom_name" {
  description = "Azure Backup Vault custom name. Empty by default, using naming convention."
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

variable "postgresql_backup_policy_custom_name" {
  description = "Azure Backup - PostgreSQL backup policy custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "managed_disk_backup_policy_custom_name" {
  description = "Azure Backup - Managed disk backup policy custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "storage_blob_backup_policy_custom_name" {
  description = "Azure Backup - Storage blob backup policy custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}
