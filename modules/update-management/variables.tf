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
  description = "Azure location"
  type        = string
}

variable "location_cli" {
  description = "Azure location in CLI format"
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for all resources generated name"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Additional tags to add"
  type        = map(string)
  default     = null
}
###############################
# Update management variables
###############################

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID where the logs are sent and linked to Automation account"
  type        = string
}

variable "automation_account_name" {
  description = "Automation account name"
  type        = string
}

variable "update_management_os" {
  description = "List of OS to cover. Possible values can be `Windows` or `Linux`. Define empty list to disable update management"
  type        = list(string)
}

variable "update_management_scope" {
  description = "Scope of the update management, it can be a subscription ID, a resource group ID etc.."
  type        = list(string)
  default     = null
}

## Default Update Management variables

variable "update_management_duration" {
  description = "To set the maintenance window, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H)"
  type        = string
  default     = "PT2H"
}

variable "update_management_tags_filtering" {
  description = "Filter scope using tags on VMs. Example : ```{ os_family = [\"linux\"] }```"
  type        = map(any)
  default     = {}
}

variable "update_management_tags_filtering_operator" {
  description = "Filter VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`"
  type        = string
  default     = "Any"
}

variable "update_management_schedule" {
  description = "Map of schedule parameters for update management. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object)"
  type        = list(any)
}

## Linux specific Update Management variables

variable "linux_update_management_duration" {
  description = "To set the maintenance window for Linux machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H)"
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
  description = "Filter Linux VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`"
  type        = string
  default     = null
}

variable "linux_update_management_schedule" {
  description = "Map of specific schedule parameters for update management of Linux machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object)"
  type        = list(any)
  default     = null
}

variable "linux_update_management_configuration" {
  description = "Linux specific update management configuration. Possible values for reboot_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#linuxproperties)"
  type        = any
  default = {
    update_classifications = "Critical, Security"
    reboot_setting         = "IfRequired"
    included_packages      = []
    excluded_packages      = []
  }
}

variable "linux_update_management_config_name" {
  description = "Custom configuration name for Linux Update management"
  type        = string
  default     = "Standard Linux Update Schedule"
}

## Windows specific Update Management variables

variable "windows_update_management_duration" {
  description = "To set the maintenance window for Windows machines, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H)"
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
  description = "Filter Windows VMs by `Any` or `All` specified tags. Possible values are `All` or `Any`"
  type        = string
  default     = null
}

variable "windows_update_management_schedule" {
  description = "Map of specific schedule parameters for update management of Windows machines. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object)"
  type        = list(any)
  default     = null
}

variable "windows_update_management_configuration" {
  description = "Windows specific update management configuration. Possible values for reboot_setting are `IfRequired`, `RebootOnly`, `Never`, `Always`. More informations on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#windowsproperties)"
  type        = any
  default = {
    update_classifications = "Critical, Security"
    reboot_setting         = "IfRequired"
    included_kb_numbers    = []
    excluded_kb_numbers    = []
  }
}

variable "windows_update_management_name" {

  description = "Custom configuration name for Windows Update management"
  type        = string
  default     = "Standard Windows Update Schedule"
}
