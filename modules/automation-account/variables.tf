variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
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

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "automation_account_extra_tags" {
  description = "Extra tags to add to automation account"
  type        = map(string)
  default     = {}
}

variable "automation_account_sku" {
  description = "Automation account Sku"
  type        = string
  default     = "Basic"
}

variable "custom_automation_account_name" {
  description = "Automation account custom name"
  type        = string
  default     = ""
}

variable "law_resource_group_name" {
  description = "Resource group of Log Analytics Workspace that will be connected with the automation account (default is the same RG that the one hosting the automation account)"
  type        = string
  default     = ""
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID that will be connected with the automation account"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}
