resource "azurerm_storage_table" "main" {
  name               = "LogQueries"
  storage_account_id = module.function.storage_account_id

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_table_entity" "main" {
  for_each = local.log_queries

  # AzureRM 5.0 requires a Resource Manager ID here, the Data Plane URL format that `id`
  # carries for a Storage Table is no longer accepted.
  storage_table_id = azurerm_storage_table.main.resource_manager_id

  partition_key = "LogQuery"
  row_key       = each.key
  entity        = each.value
}
