###############################
# Global variables
###############################
variable "tenant_id" {
  description = "Tenant ID."
  type        = string
  default     = null
}

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

###############################
# Features flags
###############################
variable "backup_vm_enabled" {
  description = ""
  type = bool
  default = false
}

variable "backup_fileshare_enabled" {
  description = ""
  type = bool
  default = false
}

variable "backup_postgresql_enabled" {
  description = ""
  type = bool
  default = false
}

variable "automation_account_enabled" {
  description = ""
  type = bool
  default = false
}

variable "update_management_legacy_enabled" {
  description = ""
  type = bool
  default = false
}

variable "update_management_enabled" {
  description = ""
  type = bool
  default = false
}
