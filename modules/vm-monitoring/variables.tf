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

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID where the metrics are sent"
  type        = string
}

variable "syslog_facilities_names" {
  description = "List of syslog to retrieve in Data Collection Rule"
  type        = list(string)
  default = ["auth", "authpriv", "cron", "daemon", "mark", "kern", "local0", "local1", "local2", "local3", "local4",
  "local5", "local6", "local7", "lpr", "mail", "news", "syslog", "user", "UUCP"]
}

variable "syslog_levels" {
  description = "List of syslog levels to retrieve in Data Collection Rule"
  type        = list(string)
  default     = ["Error", "Critical", "Alert", "Emergency"]
}
