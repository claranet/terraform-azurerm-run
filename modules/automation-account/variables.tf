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

variable "automation_account_sku" {
  description = "Automation account Sku"
  type        = string
  default     = "Basic"
}

## Identity variables
variable "automation_account_identity_type" {
  description = "Automation Account identity type. Possible values include: `null`, `SystemAssigned` and `UserAssigned`."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

variable "log_analytics_resource_group_name" {
  description = "Log Analytics Workspace resource group name (if different from `resource_group_name` variable.)"
  type        = string
  default     = null
}

variable "log_analytics_workspace_link_enabled" {
  description = "Enable Log Analytics Workspace that will be connected with the automation account"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID that will be connected with the automation account"
  type        = string
  default     = ""
}
