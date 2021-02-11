locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  automation_account_name = coalesce(
    var.custom_automation_account_name,
    "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-aa",
  )
}
