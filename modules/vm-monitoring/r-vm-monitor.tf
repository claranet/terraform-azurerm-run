data "azurerm_client_config" "current" {}

data "template_file" "data_collection_rule" {
  template = file(format("%s/files/data-collection-rule.json.tpl", path.module))

  vars = {
    location                   = var.location
    log_analytics_workspace_id = var.log_analytics_workspace_id
    syslog_facility_names      = jsonencode(var.syslog_facilities_names)
    syslog_levels              = jsonencode(var.syslog_levels)
    tags                       = jsonencode(merge(local.default_tags, var.extra_tags))
  }
}

resource "null_resource" "data_collection_rule" {
  provisioner "local-exec" {
    command = <<EOC
      az rest --subscription ${local.subscription_id} \
              --method PUT \
              --url https://management.azure.com${local.data_collection_rule_id}?api-version=2019-11-01-preview \
              --body '${data.template_file.data_collection_rule.rendered}'
EOC
  }

  triggers = {
    data = md5(data.template_file.data_collection_rule.rendered)
  }
}
