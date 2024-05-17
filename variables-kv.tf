###############################
# Key Vault variables
###############################
variable "keyvault_resource_group_name" {
  description = "Resource Group the Key Vault will belong to. Will use `resource_group_name` if not set."
  type        = string
  default     = ""
}

variable "keyvault_sku" {
  description = "The Name of the SKU used for this Key Vault. Possible values are \"standard\" and \"premium\"."
  type        = string
  default     = "standard"
}

variable "keyvault_custom_name" {
  description = "Name of the Key Vault, generated if not set."
  type        = string
  default     = ""
}

variable "keyvault_enabled_for_deployment" {
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  type        = bool
  default     = false
}

variable "keyvault_enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}

variable "keyvault_enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  type        = bool
  default     = false
}

variable "keyvault_admin_objects_ids" {
  description = "Ids of the objects that can do all operations on all keys, secrets and certificates"
  type        = list(string)
  default     = []
}

variable "keyvault_reader_objects_ids" {
  description = "Ids of the objects that can read all keys, secrets and certificates"
  type        = list(string)
  default     = []
}

variable "keyvault_network_acls" {
  description = "Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more informations."
  type = object({
    bypass                     = optional(string, "None"),
    default_action             = optional(string, "Deny"),
    ip_rules                   = optional(list(string)),
    virtual_network_subnet_ids = optional(list(string)),
  })
  default = {}
}

variable "keyvault_soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. This value can be between `7` and `90` days."
  type        = number
  default     = 7
}

variable "keyvault_rbac_authorization_enabled" {
  description = "Whether the Key Vault uses Role Based Access Control (RBAC) for authorization of data actions instead of access policies."
  type        = bool
  default     = false
}

variable "keyvault_public_network_access_enabled" {
  description = "Whether access to the Key Vault, from a public network is allowed."
  type        = bool
  default     = false
}

# Keyvault Diagnotics

variable "keyvault_logs_categories" {
  type        = list(string)
  description = "Log categories to send to destinations. All by default."
  default     = null
}

variable "keyvault_logs_metrics_categories" {
  type        = list(string)
  description = "Metrics categories to send to destinations. All by default."
  default     = null
}

# Keyvault HSM

variable "keyvault_managed_hardware_security_module_enabled" {
  description = "Create a KeyVault Managed HSM resource if enabled. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}
