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

###############################
# Azure Recovery Vault variables
###############################

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

variable "recovery_vault_storage_mode_type" {
  description = "The storage type of the Recovery Services Vault. Possible values are `GeoRedundant`, `LocallyRedundant` and `ZoneRedundant`. Defaults to `GeoRedundant`."
  type        = string
  default     = "GeoRedundant"
}

variable "recovery_vault_cross_region_restore_enabled" {
  description = "Is cross region restore enabled for this Vault? Only can be `true`, when `storage_mode_type` is `GeoRedundant`. Defaults to `false`."
  type        = bool
  default     = false
}

variable "recovery_vault_soft_delete_enabled" {
  description = "Is soft delete enable for this Vault? Defaults to `true`."
  type        = bool
  default     = true
}

###############################
# VM Backup
###############################

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

###############################
# File Share backup
###############################

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

###############################
# Azure Automation Account variables
###############################
variable "automation_account_sku" {
  description = "Automation account Sku"
  type        = string
  default     = "Basic"
}

variable "log_analytics_resource_group_name" {
  description = "Log Analytics Workspace resource group name (if different from `resource_group_name` variable.)"
  type        = string
  default     = null
}

variable "log_analytics_workspace_link_enabled" {
  description = "Enable Log Analytics Workspace that will be connected with the automation account"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID where the logs are sent and linked to Automation account"
  type        = string
}

## Identity variables
variable "automation_account_identity_type" {
  description = "Automation Account identity type. Possible values include: `null`, `SystemAssigned` and `UserAssigned`."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

###############################
# Update management variables
###############################

variable "update_management_os_list" {
  description = "List of OS to cover. Possible values can be `Windows` or `Linux`. Define empty list to disable update management."
  type        = list(string)
}

variable "update_management_scope" {
  description = "Scope of the update management, it can be a subscription ID, a resource group ID etc.."
  type        = list(string)
  default     = null
}

## Default Update Management variables

variable "update_management_duration" {
  description = "To set the maintenance window, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H)."
  type        = string
  default     = "PT2H"
}

variable "update_management_tags_filtering" {
  description = "Filter scope using tags on VMs. Example : ```{ os_family = [\"linux\"] }```"
  type        = map(any)
  default     = {}
}

variable "update_management_tags_filtering_operator" {
  description = "Filter VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`."
  type        = string
  default     = "Any"
}

variable "update_management_schedule" {
  description = "List of Map with schedule parameters for update management. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object)"
  type        = list(any)
}

variable "deploy_update_management_solution" {
  description = "Should we deploy the Log Analytics Update solution or not"
  type        = bool
  default     = true
}

## Linux specific Update Management variables

variable "linux_update_management_duration" {
  description = "To set the maintenance window for Linux machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H)."
  type        = string
  default     = null
}

variable "linux_update_management_scope" {
  description = "Scope of the update management for Linux machines, it can be a subscription ID, a resource group ID etc.."
  type        = list(string)
  default     = null
}

variable "linux_update_management_tags_filtering" {
  description = "Filter scope for Linux machines using tags on VMs. Example : ```{ os_family = [\"linux\"] }```"
  type        = map(any)
  default     = null
}

variable "linux_update_management_tags_filtering_operator" {
  description = "Filter Linux VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`."
  type        = string
  default     = null
}

variable "linux_update_management_schedule" {
  description = "Map of specific schedule parameters for update management of Linux machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object)"
  type        = list(any)
  default     = null
}

variable "linux_update_management_configuration" {
  description = "Linux specific update management configuration. Possible values for reboot_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#linuxproperties)."
  type        = any
  default = {
    update_classifications = "Critical, Security"
    reboot_setting         = "IfRequired"
    included_packages      = []
    excluded_packages      = []
  }
}

## Windows specific Update Management variables

variable "windows_update_management_duration" {
  description = "To set the maintenance window for Windows machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H)."
  type        = string
  default     = null
}

variable "windows_update_management_scope" {
  description = "Scope of the update management for Windows machines, it can be a subscription ID, a resource group ID etc.."
  type        = list(string)
  default     = null
}

variable "windows_update_management_tags_filtering" {
  description = "Filter scope for Windows machines using tags on VMs. Example : ```{ os_family = [\"windows\"] }```"
  type        = map(any)
  default     = null
}

variable "windows_update_management_tags_filtering_operator" {
  description = "Filter Windows VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`."
  type        = string
  default     = null
}

variable "windows_update_management_schedule" {
  description = "Map of specific schedule parameters for update management of Windows machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object)"
  type        = list(any)
  default     = null
}

variable "windows_update_management_configuration" {
  description = "Windows specific update management configuration. Possible values for reboot_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#windowsproperties)."
  type        = any
  default = {
    update_classifications = "Critical, Security"
    reboot_setting         = "IfRequired"
    included_kb_numbers    = []
    excluded_kb_numbers    = []
  }
}

###############################
# VM Monitoring variables
###############################

variable "data_collection_syslog_facilities_names" {
  description = "List of syslog to retrieve in Data Collection Rule"
  type        = list(string)
  default = ["auth", "authpriv", "cron", "daemon", "mark", "kern", "local0", "local1", "local2", "local3", "local4",
  "local5", "local6", "local7", "lpr", "mail", "news", "syslog", "user", "uucp"]
}

variable "data_collection_syslog_levels" {
  description = "List of syslog levels to retrieve in Data Collection Rule"
  type        = list(string)
  default     = ["Error", "Critical", "Alert", "Emergency"]
}
