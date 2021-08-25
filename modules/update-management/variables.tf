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

variable "update_management_update_classifications" {
  description = "Update Management update classifications. This variable is used to define what kind of updates do you want to apply. Possible values are `Critical`, `Security` and `Other`"
  type        = list(string)
  default     = ["Critical", "Security"]
}

variable "update_management_reboot_setting" {
  description = "Used to define the reboot setting you want. Possible values are `IfRequired`, `RebootOnly`, `Never`, `Always`."
  type        = string
  default     = "Never"
}

variable "update_management_duration" {
  description = "To set the maintenance window, the duration must be a minimum of 30 minutes and less than 6 hours. The last 20 minutes of the maintenance window is dedicated for machine restart and any remaining updates will not be started once this interval is reached. In-progress updates will finish being applied. This parameter needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. Defaults to 2 hours (PT2H)."
  type        = string
  default     = "PT2H"
}

variable "update_management_scope" {
  description = "Scope of the update management, it can be a subscription ID, a resource group ID etc.."
  type        = list(string)
  default     = []
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
  description = "Map of schedule parameters for update management. All parameters are available on the [documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json#sucscheduleproperties-object)"
  type        = list(any)
  default     = []
}

variable "update_management_os" {
  description = "List of OS to cover. Possible values can be `Windows` or `Linux`. Define empty list to disable update management."
  type        = list(string)
}
