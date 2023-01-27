variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
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

variable "extra_tags" {
  description = "Extra tags to add."
  type        = map(string)
  default     = {}
}
