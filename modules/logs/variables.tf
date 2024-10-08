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

###############################
# Log Management variables
###############################
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

variable "logs_storage_account_kind" {
  description = "Storage Account Kind."
  type        = string
  default     = "StorageV2"
}

variable "logs_storage_account_tier" {
  description = "Storage Account tier."
  type        = string
  default     = "Standard"
}

variable "logs_storage_account_access_tier" {
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`."
  type        = string
  default     = "Hot"
}

variable "logs_storage_account_replication_type" {
  description = "Storage Account Replication type."
  type        = string
  default     = "LRS"
}

variable "logs_storage_min_tls_version" {
  description = "Storage Account minimal TLS version."
  type        = string
  default     = "TLS1_2"
}

variable "logs_storage_account_advanced_threat_protection_enabled" {
  description = "Enable/disable Advanced Threat Protection, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information."
  type        = bool
  default     = false
}

variable "logs_storage_account_https_traffic_only_enable" {
  description = "Enable/disable HTTPS traffic only."
  type        = bool
  default     = true
}

variable "logs_storage_account_archived_logs_fileshare_enabled" {
  description = "Enable/disable archived-logs file share creation."
  type        = bool
  default     = false
}

variable "logs_storage_account_archived_logs_fileshare_quota" {
  description = "The maximum size in GB of the archived-logs file share, default is 5120."
  type        = number
  default     = null
}

variable "logs_storage_account_archiving_enabled" {
  description = "Enable/disable blob archiving lifecycle."
  type        = bool
  default     = true
}

variable "tier_to_cool_after_days_since_modification_greater_than" {
  description = "Change blob tier to cool after x days without modification."
  type        = number
  default     = 30
}

variable "tier_to_archive_after_days_since_modification_greater_than" {
  description = "Change blob tier to Archive after x days without modification."
  type        = number
  default     = 90
}

variable "delete_after_days_since_modification_greater_than" {
  description = "Delete blob after x days without modification."
  type        = number
  default     = 365
}

variable "logs_storage_account_customer_managed_key" {
  description = "Customer Managed Key. Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#customer_managed_key) for more information."
  type = object({
    key_vault_key_id          = optional(string)
    managed_hsm_key_id        = optional(string)
    user_assigned_identity_id = optional(string)
  })
  default = null
}


variable "logs_storage_account_identity_type" {
  description = "The identity type of the storage account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`."
  type        = string
  default     = "SystemAssigned"
}

variable "logs_storage_account_identity_ids" {
  description = "List of User Assigned Identity IDs to assign to the Storage Account."
  type        = list(string)
  default     = null
}
