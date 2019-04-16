###############################
# Global variables
###############################
variable "client_name" {
  description = "Client name"
  type        = "string"
}

variable "environment" {
  description = "Environment name"
  type        = "string"
}

variable "stack" {
  description = "Stack name"
  type        = "string"
}

variable "resource_group_name" {
  description = "Resource Group the resources will belong to"
  type        = "string"
}

variable "location" {
  description = "Azure location."
  type        = "string"
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = "string"
}

variable "name_prefix" {
  description = "Name prefix for all resources generated name"
  type        = "string"
  default     = ""
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = "map"
  default     = {}
}

###############################
# Log Management variables
###############################
variable "log_analytics_workspace_name_prefix" {
  description = "Log Analytics name prefix"
  type        = "string"
  default     = ""
}

variable "log_analytics_workspace_extra_tags" {
  description = "Extra tags to add to the Log Analytics Workspace"
  type        = "map"
  default     = {}
}

variable "log_analytics_workspace_custom_name" {
  description = "Azure Log Analytics Workspace custom name. Empty by default, using naming convention."
  type        = "string"
  default     = ""
}

variable "log_analytics_workspace_sku" {
  description = "Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03)."
  type        = "string"
  default     = "PerGB2018"
}

variable "log_analytics_workspace_retention_in_days" {
  description = "The workspace data retention in days. Possible values range between 30 and 730."
  default     = 30
}

variable "logs_storage_account_name_prefix" {
  description = "Storage Account name prefix"
  type        = "string"
  default     = ""
}

variable "logs_storage_account_custom_name" {
  description = "Storage Account for logs custom name. Empty by default, using naming convention."
  type        = "string"
  default     = ""
}

variable "logs_storage_account_extra_tags" {
  description = "Extra tags to add to Storage Account"
  type        = "map"
  default     = {}
}

variable "logs_storage_account_sas_expiry" {
  description = "Storage Account SAS Token end date (expiry). Specifies the UTC datetime (Y-m-d'T'H:M'Z') at which the SAS becomes invalid."
  type        = "string"
  default     = "2042-01-01T00:00:00Z"
}
