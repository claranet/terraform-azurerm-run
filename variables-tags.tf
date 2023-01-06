variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Extra tags to add."
  type        = map(string)
  default     = {}
}

variable "automation_account_extra_tags" {
  description = "Extra tags to add to automation account."
  type        = map(string)
  default     = {}
}

variable "recovery_vault_extra_tags" {
  description = "Extra tags to add to recovery vault."
  type        = map(string)
  default     = {}
}
