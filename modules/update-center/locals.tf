locals {
  mg_assignment_scopes               = toset([for x in var.auto_assessment_scopes : x if contains(split("/", lower(x)), "managementgroups")])
  subscriptions_assignment_scopes    = toset([for x in var.auto_assessment_scopes : x if length(split("/", x)) == 3 && try(split("/", lower(x))[1] == "subscriptions", false)])
  resource_group_assignment_scopes   = toset([for x in var.auto_assessment_scopes : x if length(split("/", x)) == 5 && try(split("/", lower(x))[3] == "resourcegroups", false)])
  virtual_machines_assignment_scopes = toset([for x in var.auto_assessment_scopes : x if length(split("/", x)) == 9 && try(split("/", lower(x))[7] == "virtualmachines", false)])

  rg_id = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_client_config.current.subscription_id, var.resource_group_name)
}
