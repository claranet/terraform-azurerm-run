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

variable "maintenance_configurations" {
  description = "Maintenance configurations following the [provider's documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/maintenance-configurations)."
  type = list(object({
    configuration_name = string
    start_date_time    = string
    duration           = optional(string, "02:00")
    time_zone          = optional(string, "UTC")
    recur_every        = string
    reboot_setting     = optional(string, "IfRequired")
    windows_classifications_to_include = optional(list(string), [
      "Critical",
      "Definition",
      "FeaturePack",
      "Security",
      "ServicePack",
      "Tools",
      "UpdateRollup",
      "Updates"
    ])
    linux_classifications_to_include = optional(list(string), [
      "Critical",
      "Security",
      "Other",
    ])
    windows_kb_numbers_to_exclude  = optional(list(string), [])
    windows_kb_numbers_to_include  = optional(list(string), [])
    linux_package_names_to_exclude = optional(list(string), [])
    linux_package_names_to_include = optional(list(string), [])
  }))
  default = []
}

variable "auto_assessment_enabled" {
  description = "Enable auto-assessment (every 24 hours) for OS updates on native Azure virtual machines by assigning Azure Policy."
  type        = bool
  default     = true
}

variable "auto_assessment_scopes" {
  description = "Scope to assign the Azure Policy for auto-assessment. Can be Management Groups, Subscriptions, Resource Groups or Virtual Machines."
  type        = list(string)
  default     = []
}

variable "auto_assessment_exclusions" {
  description = "Exclude some resources from auto-assessment."
  type        = list(string)
  default     = []
}

variable "name_prefix" {
  description = "Prefix for the maintenance configurations names."
  type        = string
  default     = "mc-"
}

variable "dynamic_scope_assignment" {
  description = "Enable dynamic scope assignment for maintenance configurations."
  type = object({
    enabled     = optional(bool, false)
    name_prefix = optional(string, "mcds-")
    filter = optional(object({
      locations       = list(string)
      os_types        = optional(list(string), ["Linux", "Windows"])
      resource_groups = optional(list(string))
      resource_types  = optional(list(string))
      tag_filter      = optional(string, "Any")
      tags = optional(list(object({
        key    = string
        values = list(string)
      })), [])
    }))
  })
  default  = {}
  nullable = false
}
