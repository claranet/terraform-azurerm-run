resource "azurerm_storage_table" "queries" {
  name                 = "LogQueries"
  storage_account_name = module.function.storage_account_name

  depends_on = [module.function, data.http.myip]
}

resource "azurerm_storage_table_entity" "queries" {
  for_each = local.log_queries

  storage_account_name = module.function.storage_account_name
  table_name           = azurerm_storage_table.queries.name

  partition_key = "LogQuery"
  row_key       = each.key
  entity        = each.value
}
