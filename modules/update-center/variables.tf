###############################
# Global variables
###############################

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
  description = "Resource group to which the resources will belong."
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
