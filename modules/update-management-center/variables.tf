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
  description = "Resource Group the resources will belong to."
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

variable "maintenance_configurations" {
  description = "Maintenance configurations. https://learn.microsoft.com/en-us/azure/virtual-machines/maintenance-configurations"
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
  }))
  default = []
}

variable "virtual_machines_associations" {
  description = "Associate Virtual Machine to Maintenance Configuration."
  type = list(object({
    virtual_machine_id             = string
    maintenance_configuration_name = string
  }))
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
