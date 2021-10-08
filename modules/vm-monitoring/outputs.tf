output "data_collection_rule_id" {
  description = "Id of the Azure Monitor Data Collection Rule"
  value       = local.data_collection_rule_id
}

output "data_collection_rule_name" {
  description = "Name of the Azure Monitor Data Collection Rule"
  value       = local.name
}

output "data_collection_rule_data" {
  description = "JSON data of the Azure Monitor Data Collection Rule"
  value       = local.data_collection_config
}
