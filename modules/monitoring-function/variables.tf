###############################
# Global variables
###############################
variable "client_name" {
  description = "Client name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "stack" {
  description = "Stack name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to which the resources will belong."
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

variable "log_analytics_workspace_guid" {
  description = "GUID of the Log Analytics Workspace on which evaluate the queries."
  type        = string
}

variable "splunk_token" {
  description = "Access Token to send metrics to Splunk Observability."
  type        = string
}

variable "zip_package_path" {
  description = "Zip package path for monitoring function."
  type        = string
  default     = "https://github.com/claranet/fame/releases/download/v1.2.1/fame.zip"
}

variable "metrics_extra_dimensions" {
  description = "Extra dimensions sent with metrics."
  type        = map(string)
  default     = {}
}

variable "extra_application_settings" {
  description = "Extra application settings to set on monitoring function."
  type        = map(string)
  default     = {}
}

variable "storage_account_advanced_threat_protection_enabled" {
  description = "FAME advanded thread protection (aka ATP) on Function App's storage account."
  type        = bool
  default     = false
}

variable "rbac_storage_contributor_role_principal_ids" {
  description = "The principal IDs of the users, groups, and service principals to assign the `Storage Account Contributor` role to."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "rbac_storage_table_role_principal_ids" {
  description = "The principal IDs of the users, groups, and service principals to assign the `Storage Table Data *` role to."
  type = object({
    contributors = optional(list(string), [])
    readers      = optional(list(string), [])
  })
  default  = {}
  nullable = false
}

variable "application_insights_enabled" {
  description = "Whether Application Insights should be deployed."
  type        = bool
  default     = true
}

variable "application_insights_log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace to be used with Application Insights."
  type        = string
}
