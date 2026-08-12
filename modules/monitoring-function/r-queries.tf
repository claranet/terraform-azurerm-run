resource "azurerm_storage_table" "main" {
  name               = "LogQueries"
  storage_account_id = module.function.storage_account_id

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_table_entity" "main" {
  for_each = local.log_queries

  storage_table_id = azurerm_storage_table.main.id

  partition_key = "LogQuery"
  row_key       = each.key
  entity        = each.value
}
