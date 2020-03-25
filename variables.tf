###############################
# Global variables
###############################
variable "tenant_id" {
  description = "Tenant ID"
  type        = string
}

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

variable "name_prefix" {
  description = "Name prefix for all resources generated name"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

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

variable "log_analytics_workspace_extra_tags" {
  description = "Extra tags to add to the Log Analytics Workspace"
  type        = map(string)
  default     = {}
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

variable "log_analytics_workspace_enable_iis_logs" {
  description = "Specifies if IIS logs should be collected for linked Virtual Machines"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_retention_in_days" {
  description = "The workspace data retention in days. Possible values range between 30 and 730."
  default     = 30
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

variable "logs_storage_account_appservices_container_name" {
  description = "Name of the container in which App Services logs are stored"
  type        = string
  default     = "app-services"
}

variable "logs_storage_account_enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information."
  type        = bool
  default     = false
}

variable "logs_storage_account_enable_https_traffic_only" {
  description = "Boolean flag which controls if https traffic only is enabled."
  type        = bool
  default     = true
}

variable "logs_storage_account_enable_archived_logs_fileshare" {
  description = "Boolean flag which controls if archived-logs file share should be created."
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

###############################
# Key Vault variables
###############################
variable "keyvault_resource_group_name" {
  description = "Resource Group the Key Vault will belong to. Will use `resource_group_name` if not set."
  type        = string
  default     = ""
}

variable "keyvault_sku" {
  description = "The Name of the SKU used for this Key Vault. Possible values are \"standard\" and \"premium\"."
  type        = string
  default     = "standard"
}

variable "keyvault_extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "keyvault_custom_name" {
  description = "Name of the Key Vault, generated if not set."
  type        = string
  default     = ""
}

variable "keyvault_enabled_for_deployment" {
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  type        = string
  default     = "false"
}

variable "keyvault_enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = string
  default     = "false"
}

variable "keyvault_enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  type        = string
  default     = "false"
}

variable "keyvault_admin_objects_ids" {
  description = "Ids of the objects that can do all operations on all keys, secrets and certificates"
  type        = list(string)
  default     = []
}

variable "keyvault_reader_objects_ids" {
  description = "Ids of the objects that can read all keys, secrets and certificates"
  type        = list(string)
  default     = []
}

