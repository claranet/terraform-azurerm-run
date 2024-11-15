###############################
# Log Management variables
###############################
variable "workspace_sku" {
  description = "Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018 (new Sku as of 2018-04-03)."
  type        = string
  default     = "PerGB2018"
}

variable "workspace_retention_in_days" {
  description = "The workspace data retention in days. Possible values range between 30 and 730."
  type        = number
  default     = 30
}

variable "workspace_daily_quota_gb" {
  description = "The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited)."
  type        = number
  default     = -1
}
