###############################
# Monitoring function
###############################
variable "monitoring_function_enabled" {
  description = "Enable/disable monitoring function"
  type        = bool
  default     = true
}

variable "monitoring_function_splunk_token" {
  description = "Access Token to send metrics to Splunk Observability"
  type        = string
}

variable "monitoring_function_logs_categories" {
  description = "Monitoring function log categories to send to destinations"
  type        = list(string)
  default     = null
}

variable "monitoring_function_logs_metrics_categories" {
  description = "Monitoring function metrics categories to send to destinations"
  type        = list(string)
  default     = null
}

variable "monitoring_function_extra_tags" {
  description = "Monitoring function extra tags to add"
  type        = map(string)
  default     = {}
}

variable "monitoring_function_zip_package_path" {
  description = "Zip package path for monitoring function"
  type        = string
  default     = "https://github.com/claranet/fame/releases/download/v1.0.0/fame.zip"
}

variable "monitoring_function_metrics_extra_dimensions" {
  description = "Extra dimensions sent with metrics"
  type        = map(string)
  default     = {}
}

variable "monitoring_function_assign_role_on_workspace" {
  description = "True to assign role for the monitoring Function on the Log Analytics Workspace"
  type        = bool
  default     = true
}

variable "monitoring_function_extra_application_settings" {
  description = "Extra application settings to set on monitoring Function"
  type        = map(string)
  default     = {}
}
