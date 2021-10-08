data "azurerm_client_config" "current" {}

resource "null_resource" "data_collection_rule" {
  provisioner "local-exec" {
    command = <<EOC
      az rest --subscription ${local.subscription_id} \
              --method PUT \
              --url https://management.azure.com${local.data_collection_rule_id}?api-version=2019-11-01-preview \
              --body '${local.data_collection_config}'
EOC
  }

  triggers = {
    data = md5(local.data_collection_config)
  }
}
