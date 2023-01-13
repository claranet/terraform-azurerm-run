module "update_management_center" {
  source = "./modules/update-center"

  count = var.update_center_enabled ? 1 : 0

  environment         = var.environment
  stack               = var.stack
  location            = var.location
  resource_group_name = var.resource_group_name

  auto_assessment_enabled    = var.update_center_periodic_assessment_enabled
  auto_assessment_scopes     = var.update_center_periodic_assessment_scopes
  auto_assessment_exclusions = var.update_center_periodic_assessment_exclusions

  maintenance_configurations = var.update_center_maintenance_configurations
}
