###############################
# Global variables
###############################
variable "client_name" {
  description = "Client name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "stack" {
  description = "Stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group the resources will belong to"
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

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

###############################
# Log Management variables
###############################
variable "log_analytics_workspace_extra_tags" {
  description = "Extra tags to add to the Log Analytics Workspace"
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_sku" {
  description = "Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03)."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_workspace_retention_in_days" {
  description = "The workspace data retention in days. Possible values range between 30 and 730."
  type        = number
  default     = 30
}

variable "log_analytics_workspace_enable_iis_logs" {
  description = "Specifies if IIS logs should be collected for linked Virtual Machines"
  type        = bool
  default     = false
}

variable "logs_storage_account_extra_tags" {
  description = "Extra tags to add to Storage Account"
  type        = map(string)
  default     = {}
}

variable "logs_storage_account_kind" {
  description = "Storage Account Kind"
  type        = string
  default     = "StorageV2"
}

variable "logs_storage_min_tls_version" {
  description = "Storage Account minimal TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "logs_storage_account_sas_expiry" {
  description = "Storage Account SAS Token end date (expiry). Specifies the UTC datetime (Y-m-d'T'H:M'Z') at which the SAS becomes invalid."
  type        = string
  default     = "2042-01-01T00:00:00Z"
}

variable "logs_storage_account_enable_appservices_container" {
  description = "Boolean flag which controls if App Services logs container should be created."
  type        = bool
  default     = false
}

variable "logs_storage_account_enable_advanced_threat_protection" {
  description = "Enable/disable Advanced Threat Protection, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information."
  type        = bool
  default     = false
}

variable "logs_storage_account_enable_https_traffic_only" {
  description = "Enable/disable HTTPS traffic only"
  type        = bool
  default     = true
}

variable "logs_storage_account_enable_archived_logs_fileshare" {
  description = "Enable/disable archived-logs file share creation"
  type        = bool
  default     = false
}

variable "logs_storage_account_archived_logs_fileshare_quota" {
  description = "The maximum size in GB of the archived-logs file share, default is 5120"
  type        = number
  default     = null
}

variable "logs_storage_account_enable_archiving" {
  description = "Enable/disable blob archiving lifecycle"
  type        = bool
  default     = true
}

variable "tier_to_cool_after_days_since_modification_greater_than" {
  description = "Change blob tier to cool after x days without modification"
  type        = number
  default     = 30
}

variable "tier_to_archive_after_days_since_modification_greater_than" {
  description = "Change blob tier to Archive after x days without modification"
  type        = number
  default     = 90
}

variable "delete_after_days_since_modification_greater_than" {
  description = "Delete blob after x days without modification"
  type        = number
  default     = 365
}
