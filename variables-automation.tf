###############################
# Azure Automation Account variables
###############################

variable "automation_account_enabled" {
  description = "Whether the Automation Account is enabled. Enabled if legacy Update Management is enabled."
  type        = bool
  default     = false
}

variable "automation_account_sku" {
  description = "Automation account Sku."
  type        = string
  default     = "Basic"
}

variable "log_analytics_resource_group_name" {
  description = "Log Analytics Workspace resource group name (if different from `resource_group_name` variable.)."
  type        = string
  default     = null
}

variable "log_analytics_workspace_link_enabled" {
  description = "Enable Log Analytics Workspace that will be connected with the automation account."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID where the logs are sent and linked to Automation account."
  type        = string
  default     = null
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

# Diag settings / logs parameters

variable "automation_logs_destinations_ids" {
  type        = list(string)
  description = <<EOD
List of destination resources IDs for logs diagnostic destination.
Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.
If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character.
EOD
  default     = []
}

variable "automation_logs_categories" {
  type        = list(string)
  description = "Log categories to send to destinations."
  default     = null
}

variable "automation_logs_metrics_categories" {
  type        = list(string)
  description = "Metrics categories to send to destinations."
  default     = null
}

variable "automation_diagnostic_settings_custom_name" {
  description = "Custom name of the diagnostics settings, name will be 'default' if not set."
  type        = string
  default     = "default"
}
