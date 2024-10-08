###############################
# Key Vault outputs
###############################
output "keyvault_resource_group_name" {
  description = "Resource Group of the Key Vault."
  value       = var.keyvault_resource_group_name
}

output "keyvault_id" {
  description = "ID of the Key Vault."
  value       = module.keyvault.id
}

output "keyvault_name" {
  description = "Name of the Key Vault."
  value       = module.keyvault.name
}

output "keyvault_uri" {
  description = "URI of the Key Vault."
  value       = module.keyvault.uri
}

output "key_vault_hsm_uri" {
  description = "The URI of the Key Vault Managed Hardware Security Module, used for performing operations on keys."
  value       = module.keyvault.hsm_uri
}

output "module_keyvault" {
  description = "Key Vault module outputs."
  value       = module.keyvault
}
