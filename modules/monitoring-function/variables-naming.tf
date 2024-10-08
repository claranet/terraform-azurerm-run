# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = "fame"
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

# Custom naming override
variable "storage_account_custom_name" {
  description = "FAME Storage Account custom name. Empty by default, using naming convention."
  type        = string
  default     = null
}

variable "function_app_custom_name" {
  description = "FAME Function App custom name"
  type        = string
  default     = null
}

variable "application_insights_custom_name" {
  description = "FAME Application Insights custom name deployed with function app"
  type        = string
  default     = null
}

variable "service_plan_custom_name" {
  description = "FAME Service Plan custom name"
  type        = string
  default     = null
}
