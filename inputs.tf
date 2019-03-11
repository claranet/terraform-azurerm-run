# Global variables
variable "client_name" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "stack" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "location" {
  description = "Azure location for App Service Plan."
  type        = "string"
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = "string"
}

# Feature variables

variable "name_prefix" {
  description = "Name prefix for all resources generated name"
  type        = "string"
  default     = ""
}

variable "storage_account_name_suffix" {
  description = "Storage Account name suffix"
  type        = "string"
  default     = ""
}

variable "storage_account_extra_tags" {
  description = "Extra tags to add to Storage Account"
  type        = "map"
  default     = {}
}

variable "storage_account_sas_start" {
  description = "Storage Account SAS Token - start date"
  type        = "string"
}

variable "storage_account_sas_expiry" {
  description = "Storage Account SAS Token - end date (expiry)"
  type        = "string"
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = "map"
  default     = {}
}

variable "log_analytics_custom_name" {
  description = "Azure log analytics custom name. Empty by default, using naming convention."
  type        = "string"
  default     = ""
}

variable "log_analytics_sku" {
  description = "Specifies the Sku of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03)."
  type        = "string"
  default     = "PerGB2018"
}

variable "log_analytics_retention_in_days" {
  description = "The workspace data retention in days. Possible values range between 30 and 730."
  default     = 30
}

# TODO Remove me in Terraform 0.12
variable "create_storage_account_resource" {
  description = "Flag indicating if Storage Account resource should be automatically created (needed until Terraform 0.12), otherwise, variable `storage_account_connection_string` must be set. Default to `true`"
  type        = "string"
  default     = "true"
}

variable "storage_account_connection_string" {
  description = "Storage Account connection string for Function App associated storage, a Storage Account is created if empty"
  type        = "string"
  default     = ""
}
