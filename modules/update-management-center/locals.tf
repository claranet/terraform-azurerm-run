locals {
  mg_assignment_scopes               = toset([for x in var.auto_assessment_scopes : x if contains(split("/", lower(x)), "managementgroups")])
  subscriptions_assignment_scopes    = toset([for x in var.auto_assessment_scopes : x if length(split("/", x)) == 2 && split("/", lower(x))[0] == "subscriptions"])
  resource_group_assignment_scopes   = toset([for x in var.auto_assessment_scopes : x if length(split("/", x)) == 4 && split("/", lower(x))[2] == "resourcegroups"])
  virtual_machines_assignment_scopes = toset([for x in var.auto_assessment_scopes : x if length(split("/", x)) == 8 && split("/", lower(x))[6] == "virtualmachines"])
}

