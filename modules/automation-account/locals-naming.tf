locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  automation_account_name = coalesce(
    var.custom_automation_account_name,
    azurecaf_name.automation_account.result,
  )
}
