###############################
# Key Vault outputs
###############################
output "key_vault_resource_group_name" {
  description = "Resource Group of the Key Vault."
  value       = var.key_vault_resource_group_name
}

output "key_vault_id" {
  description = "ID of the Key Vault."
  value       = module.key_vault.id
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault."
  value       = module.key_vault.uri
}

output "key_vault_hsm_uri" {
  description = "The URI of the Key Vault Managed Hardware Security Module, used for performing operations on keys."
  value       = module.key_vault.hsm_uri
}

output "module_key_vault" {
  description = "Key Vault module outputs."
  value       = module.key_vault
}
