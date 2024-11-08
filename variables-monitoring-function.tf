###############################
# Monitoring function
###############################
variable "monitoring_function_enabled" {
  description = "Whether additional Monitoring Function is enabled."
  type        = bool
  default     = true
}

variable "monitoring_function_splunk_token" {
  description = "Access Token to send metrics to Splunk Observability."
  type        = string
  default     = null
}

variable "monitoring_function_logs_categories" {
  description = "Monitoring function log categories to send to destinations. All by default."
  type        = list(string)
  default     = null
}

variable "monitoring_function_logs_metrics_categories" {
  description = "Monitoring function metrics categories to send to destinations. All by default."
  type        = list(string)
  default     = null
}

variable "monitoring_function_zip_package_path" {
  description = "Zip package path for monitoring function."
  type        = string
  default     = "https://github.com/claranet/fame/releases/download/v1.2.1/fame.zip"
}

variable "monitoring_function_metrics_extra_dimensions" {
  description = "Extra dimensions sent with metrics."
  type        = map(string)
  default     = {}
}

variable "monitoring_function_extra_application_settings" {
  description = "Extra application settings to set on monitoring Function."
  type        = map(string)
  default     = {}
}

variable "monitoring_function_assign_roles" {
  description = "True to assign roles for the monitoring Function on the Log Analytics Workspace (Log Analytics Reader) and the Subscription (Reader)."
  type        = bool
  default     = true
}

variable "monitoring_function_application_insights_enabled" {
  description = "Whether FAME Application Insights is deployed."
  type        = bool
  default     = true
}

variable "monitoring_function_storage_account_custom_name" {
  description = "FAME Storage Account custom name. Empty by default, using naming convention."
  type        = string
  default     = null
}

variable "monitoring_function_function_app_custom_name" {
  description = "FAME Function App custom name. Empty by default, using naming convention."
  type        = string
  default     = null
}

variable "monitoring_function_application_insights_custom_name" {
  description = "FAME Application Insights custom name. Empty by default, using naming convention."
  type        = string
  default     = null
}

variable "monitoring_function_advanced_threat_protection_enabled" {
  description = "FAME function app's storage account: Enable Advanced Threat Protection."
  type        = bool
  default     = false
}

variable "monitoring_function_app_service_plan_name" {
  description = "FAME App Service Plan custom name. Empty by default, using naming convention."
  type        = string
  default     = null
}
