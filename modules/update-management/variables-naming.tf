# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name."
  type        = bool
  default     = true
}

# Custom naming override
variable "linux_update_management_configuration_name" {
  description = "Custom configuration name for Linux Update management"
  type        = string
  default     = "Standard Linux Update Schedule"
}

variable "windows_update_management_configuration_name" {

  description = "Custom configuration name for Windows Update management"
  type        = string
  default     = "Standard Windows Update Schedule"
}
