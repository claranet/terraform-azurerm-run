###############################
# Monitoring function
###############################
variable "monitoring_function_enabled" {
  description = "True to enable monitoring function"
  type        = bool
  default     = true
}

variable "monitoring_function_splunk_token" {
  description = "Access Token to send metrics to SPlunk Observability"
  type        = string
}

variable "monitoring_function_logs_categories" {
  type        = list(string)
  description = "Monitoring function log categories to send to destinations."
  default     = null
}

variable "monitoring_function_logs_metrics_categories" {
  type        = list(string)
  description = "Monitoring function metrics categories to send to destinations."
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
  default     = "https://github.com/BzSpi/azure-monitoring-test/releases/download/v0.0.1-test4/my_function.zip"
}

variable "monitoring_function_metrics_extra_dimensions" {
  description = "Extra dimensions sent with metrics"
  type        = map(string)
  default     = {}
}
