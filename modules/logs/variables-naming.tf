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

# Custom naming override
variable "workspace_name_prefix" {
  description = "Log Analytics name prefix."
  type        = string
  default     = ""
}

variable "workspace_custom_name" {
  description = "Azure Log Analytics Workspace custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "storage_account_name_prefix" {
  description = "Storage Account name prefix."
  type        = string
  default     = ""
}

variable "storage_account_custom_name" {
  description = "Storage Account for logs custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "storage_account_archived_logs_fileshare_name" {
  description = "Name of the file share in which externalized logs are stored."
  type        = string
  default     = "archived-logs"
}
