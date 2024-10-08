locals {
  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
    module.logs.storage_account_id,
  ]
}
