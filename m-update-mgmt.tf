module "update_management_center" {
  source = "./modules/update-center"

  count = var.update_center_enabled ? 1 : 0

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  name_prefix = var.name_prefix
  name_suffix = var.name_suffix

  auto_assessment_enabled    = var.update_center_periodic_assessment_enabled
  auto_assessment_scopes     = var.update_center_periodic_assessment_scopes
  auto_assessment_exclusions = var.update_center_periodic_assessment_exclusions

  maintenance_configurations = var.update_center_maintenance_configurations
  dynamic_scope_assignment   = var.update_center_dynamic_scope_assignment

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags
}

moved {
  from = module.update_management_center["enabled"]
  to   = module.update_management_center[0]
}
