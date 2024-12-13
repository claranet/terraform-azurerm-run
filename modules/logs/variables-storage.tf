###############################
# Storage Account variables
###############################

variable "storage_account_enabled" {
  description = "Whether the dedicated Storage Account for logs is created."
  type        = bool
  default     = true
}

variable "storage_account_kind" {
  description = "Storage Account Kind."
  type        = string
  default     = "StorageV2"
}

variable "storage_account_tier" {
  description = "Storage Account tier."
  type        = string
  default     = "Standard"
}

variable "storage_account_access_tier" {
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`."
  type        = string
  default     = "Hot"
}

variable "storage_account_replication_type" {
  description = "Storage Account Replication type."
  type        = string
  default     = "LRS"
}

variable "storage_account_min_tls_version" {
  description = "Storage Account minimal TLS version."
  type        = string
  default     = "TLS1_2"
}

variable "storage_account_advanced_threat_protection_enabled" {
  description = "Enable/disable Advanced Threat Protection, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information."
  type        = bool
  default     = false
}

variable "storage_account_https_traffic_only_enabled" {
  description = "Enable/disable HTTPS traffic only."
  type        = bool
  default     = true
}

variable "storage_account_archived_logs_fileshare_enabled" {
  description = "Enable/disable archived-logs file share creation."
  type        = bool
  default     = false
}

variable "storage_account_archived_logs_fileshare_quota" {
  description = "The maximum size in GB of the archived-logs file share, default is 5120."
  type        = number
  default     = null
}

variable "storage_account_archiving_enabled" {
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

variable "storage_account_customer_managed_key" {
  description = "Customer Managed Key. Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#customer_managed_key) for more information."
  type = object({
    key_vault_key_id          = optional(string)
    managed_hsm_key_id        = optional(string)
    user_assigned_identity_id = optional(string)
  })
  default = null
}


variable "storage_account_identity_type" {
  description = "The identity type of the storage account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`."
  type        = string
  default     = "SystemAssigned"
}

variable "storage_account_identity_ids" {
  description = "List of User Assigned Identity IDs to assign to the Storage Account."
  type        = list(string)
  default     = null
}

variable "storage_shared_access_key_enabled" {
  description = "Indicates whether the Storage Account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Entra ID)."
  type        = bool
  default     = false
  nullable    = false
}

variable "rbac_storage_contributor_role_principal_ids" {
  description = "The principal IDs of the users, groups, and service principals to assign the `Storage Account Contributor` role to."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "rbac_storage_blob_role_principal_ids" {
  description = "The principal IDs of the users, groups, and service principals to assign the `Storage Blob Data *` different roles to if Blob containers are created."
  type = object({
    owners       = optional(list(string), [])
    contributors = optional(list(string), [])
    readers      = optional(list(string), [])
  })
  default  = {}
  nullable = false
}
