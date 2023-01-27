###############################
# VM Monitoring variables
###############################
variable "vm_monitoring_enabled" {
  description = "Whether Data Collection Rules for VM monitoring are enabled."
  type        = bool
  default     = false
}

variable "data_collection_syslog_facilities_names" {
  description = "List of syslog to retrieve in Data Collection Rule."
  type        = list(string)
  default = ["auth", "authpriv", "cron", "daemon", "mark", "kern", "local0", "local1", "local2", "local3", "local4",
  "local5", "local6", "local7", "lpr", "mail", "news", "syslog", "user", "uucp"]
}

variable "data_collection_syslog_levels" {
  description = "List of syslog levels to retrieve in Data Collection Rule."
  type        = list(string)
  default     = ["Error", "Critical", "Alert", "Emergency"]
}
