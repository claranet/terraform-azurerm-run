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
# Azure Recovery Vault variables
###############################
variable "recovery_vault_custom_name" {
  description = "Azure Recovery Vault custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "recovery_vault_sku" {
  description = "Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`."
  type        = string
  default     = "Standard"
}

variable "recovery_vault_identity_type" {
  description = "Azure Recovery Vault identity type. Possible values include: `null`, ``SystemAssigned`. Default to `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}

variable "recovery_vault_extra_tags" {
  description = "Extra tags to add to recovery vault"
  type        = map(string)
  default     = {}
}

variable "vm_backup_policy_custom_name" {
  description = "Azure Backup - VM backup policy custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "vm_backup_policy_timezone" {
  description = "Specifies the timezone for schedules. Defaults to `UTC`."
  type        = string
  default     = "UTC"
}

variable "vm_backup_policy_time" {
  description = "The time of day to preform the backup in 24hour format."
  type        = string
  default     = "04:00"
}

variable "vm_backup_policy_frequency" {
  description = "Specifies the frequency for VM backup schedules. Must be either `Daily` or `Weekly`."
  type        = string
  default     = "Daily"
}

variable "vm_backup_daily_policy_retention" {
  description = "The number of daily VM backups to keep. Must be between 7 and 9999."
  type        = number
  default     = 30
}

variable "vm_backup_weekly" {
  description = "Map to configure the weekly backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_weekly"
  type        = any
  default     = {}
}

variable "vm_backup_monthly" {
  description = "Map to configure the monthly backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_monthly"
  type        = any
  default     = {}
}

variable "vm_backup_yearly" {
  description = "Map to configure the yearly backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm#retention_yearly"
  type        = any
  default     = {}
}

variable "file_share_backup_policy_custom_name" {
  description = "Azure Backup - File share backup policy custom name. Empty by default, using naming convention."
  type        = string
  default     = ""
}

variable "file_share_backup_policy_timezone" {
  description = "Specifies the timezone for file share backup schedules. Defaults to `UTC`."
  type        = string
  default     = "UTC"
}

variable "file_share_backup_policy_time" {
  description = "The time of day to perform the file share backup in 24hour format."
  type        = string
  default     = "04:00"
}

variable "file_share_backup_daily_policy_retention" {
  description = "The number of daily file share backups to keep. Must be between 7 and 9999."
  type        = number
  default     = 30
}

variable "file_share_backup_policy_frequency" {
  description = "Specifies the frequency for file_share backup schedules. Must be either `Daily` or `Weekly`."
  type        = string
  default     = "Daily"
}

variable "file_share_backup_weekly" {
  description = "Map to configure the weekly File Share backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_weekly"
  type        = any
  default     = {}
}

variable "file_share_backup_monthly" {
  description = "Map to configure the monthly File Share backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_monthly"
  type        = any
  default     = {}
}

variable "file_share_backup_yearly" {
  description = "Map to configure the yearly File Share backup policy according to https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_file_share#retention_yearly"
  type        = any
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID where the logs are sent and linked to Automation account"
  type        = string
}

variable "logs_destinations_ids" {
  type        = list(string)
  description = "List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging."
}

variable "logs_categories" {
  type        = list(string)
  description = "Log categories to send to destinations."
  default     = null
}

variable "logs_metrics_categories" {
  type        = list(string)
  description = "Metrics categories to send to destinations."
  default     = null
}

variable "logs_retention_days" {
  type        = number
  description = "Number of days to keep logs on storage account"
  default     = 30
}

###############################
# Azure Automation Account variables
###############################
variable "automation_account_sku" {
  description = "Automation account Sku"
  type        = string
  default     = "Basic"
}

variable "custom_automation_account_name" {
  description = "Automation account custom name"
  type        = string
  default     = ""
}

variable "log_analytics_resource_group_name" {
  description = "Log Analytics Workspace resource group name (if different from `resource_group_name` variable.)"
  type        = string
  default     = null
}

variable "automation_account_extra_tags" {
  description = "Extra tags to add to automation account"
  type        = map(string)
  default     = {}
}

###############################
# Patch management variables
###############################

## Linux 
variable "patch_mgmt_update_classifications" {
  description = "Patch Management update classifications. This variable is used to define what kind of updates do you want to apply. Possible values are `Critical`, `Security` and `Other`"
  type        = list(string)
  default     = ["Critical", "Security"]
}

variable "patch_mgmt_reboot_setting" {
  description = "Used to define the reboot setting you want. Possible values are `IfRequired`, `RebootOnly`, `Never`, `Always`."
  type        = string
  default     = "Never"
}

variable "patch_mgmt_duration" {
  description = "To set the maintenance window, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H)."
  type        = string
  default     = "PT2H"
}

variable "patch_mgmt_scope" {
  description = "Scope of the patch management, it can be a subscription ID, a resource group ID etc.."
  type        = list(string)
  default     = []
}

variable "patch_mgmt_tags_filtering" {
  description = "Filter scope using tags on VMs. Example : ```{ os_family = [\"linux\"] }```"
  type        = map(any)
  default     = {}
}

variable "patch_mgmt_tags_filtering_operator" {
  description = "Filter VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`."
  type        = string
  default     = "Any"
}

variable "patch_mgmt_schedule" {
  description = "Map of schedule parameters for patch management. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object)"
  type        = list(any)
  default     = []
}

variable "patch_mgmt_os" {
  description = "List of OS to cover. Possible values can be `Windows` or `Linux`. Define empty list to disable patch management."
  type        = list(string)
}
