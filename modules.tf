module "logs" {
  source = "./logs"

  client_name         = "${var.client_name}"
  location            = "${var.location}"
  location_short      = "${var.location_short}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${coalesce(var.logs_resource_group_name, var.resource_group_name)}"

  name_prefix = "${coalesce(var.name_prefix, "logs")}"
  extra_tags  = "${var.extra_tags}"

  logs_storage_account_name_prefix               = "${var.logs_storage_account_name_prefix}"
  logs_storage_account_custom_name               = "${var.logs_storage_account_custom_name}"
  logs_storage_account_extra_tags                = "${var.logs_storage_account_extra_tags}"
  logs_storage_account_sas_expiry                = "${var.logs_storage_account_sas_expiry}"
  logs_storage_acount_appservices_container_name = "${var.logs_storage_acount_appservices_container_name}"

  log_analytics_workspace_name_prefix       = "${var.log_analytics_workspace_name_prefix}"
  log_analytics_workspace_custom_name       = "${var.log_analytics_workspace_custom_name}"
  log_analytics_workspace_extra_tags        = "${var.log_analytics_workspace_extra_tags}"
  log_analytics_workspace_retention_in_days = "${var.log_analytics_workspace_retention_in_days}"
  log_analytics_workspace_sku               = "${var.log_analytics_workspace_sku}"
}
