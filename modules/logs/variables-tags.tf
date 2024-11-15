variable "default_tags_enabled" {
  description = "Option to enable or disable default tags"
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "workspace_extra_tags" {
  description = "Extra tags to add to the Log Analytics Workspace"
  type        = map(string)
  default     = {}
}

variable "storage_account_extra_tags" {
  description = "Extra tags to add to the Storage Account"
  type        = map(string)
  default     = {}
}
