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
variable "custom_name" {
  description = "Custom name, generated if not set"
  type        = string
  default     = ""
}
