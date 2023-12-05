###############################
# Log Management variables
###############################
variable "logs_resource_group_name" {
  description = "Resource Group the resources for log management will belong to. Will use `resource_group_name` if not set."
  type        = string
  default     = ""
}

variable "log_analytics_workspace_name_prefix" {
  description = "Log Analytics name prefix"
  type        = string
  default     = ""
}

variable "log_analytics_workspace_custom_name" {
  description = "Azure Log Analytics Workspace custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
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

variable "log_analytics_workspace_daily_quota_gb" {
  description = "The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited)."
  type        = number
  default     = -1
}

variable "logs_storage_account_enabled" {
  description = "Whether the dedicated Storage Account for logs is created."
  type        = bool
  default     = true
}

variable "logs_storage_account_name_prefix" {
  description = "Storage Account name prefix"
  type        = string
  default     = ""
}

variable "logs_storage_account_custom_name" {
  description = "Storage Account for logs custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "logs_storage_account_kind" {
  description = "Storage Account Kind"
  type        = string
  default     = "StorageV2"
}

variable "logs_storage_account_tier" {
  description = "Storage Account tier"
  type        = string
  default     = "Standard"
}

variable "logs_storage_account_access_tier" {
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`."
  type        = string
  default     = "Hot"
}

variable "logs_storage_account_replication_type" {
  description = "Storage Account Replication type"
  type        = string
  default     = "LRS"
}

variable "logs_storage_min_tls_version" {
  description = "Storage Account minimal TLS version"
  type        = string
  default     = "TLS1_2"
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

variable "logs_storage_account_archived_logs_fileshare_name" {
  description = "Name of the file share in which externalized logs are stored"
  type        = string
  default     = "archived-logs"
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

variable "logs_tier_to_cool_after_days_since_modification_greater_than" {
  description = "Change blob tier to cool after x days without modification"
  type        = number
  default     = 30
}

variable "logs_tier_to_archive_after_days_since_modification_greater_than" {
  description = "Change blob tier to Archive after x days without modification"
  type        = number
  default     = 90
}

variable "logs_delete_after_days_since_modification_greater_than" {
  description = "Delete blob after x days without modification"
  type        = number
  default     = 365
}
