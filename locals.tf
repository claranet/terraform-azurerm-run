locals {
  logs_destinations_ids = [
    module.logs.id,
    module.logs.storage_account_id,
  ]
}
