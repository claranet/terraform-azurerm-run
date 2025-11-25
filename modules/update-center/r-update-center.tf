resource "azurerm_maintenance_configuration" "main" {
  for_each = { for config in var.maintenance_configurations : config.configuration_name => config }

  name                = coalesce(each.value.custom_resource_name, data.azurecaf_name.mc[each.key].result)
  resource_group_name = var.resource_group_name
  location            = var.location

  scope      = "InGuestPatch"
  visibility = "Custom"

  window {
    start_date_time = each.value.start_date_time
    duration        = each.value.duration
    recur_every     = each.value.recur_every
    time_zone       = each.value.time_zone
  }

  in_guest_user_patch_mode = "User"

  install_patches {
    linux {
      classifications_to_include    = each.value.linux_classifications_to_include
      package_names_mask_to_exclude = each.value.linux_package_names_to_exclude
      package_names_mask_to_include = each.value.linux_package_names_to_include
    }
    windows {
      classifications_to_include = each.value.windows_classifications_to_include
      kb_numbers_to_exclude      = each.value.windows_kb_numbers_to_exclude
      kb_numbers_to_include      = each.value.windows_kb_numbers_to_include
    }
    reboot = each.value.reboot_setting
  }

  tags = local.mc_tags
}

moved {
  from = azurerm_maintenance_configuration.maintenance_configuration
  to   = azurerm_maintenance_configuration.main
}

resource "azurerm_maintenance_assignment_dynamic_scope" "main" {
  for_each = var.dynamic_scope_assignment.enabled ? azurerm_maintenance_configuration.main : {}

  name                         = try(var.dynamic_scope_assignment.custom_resource_names[each.key], data.azurecaf_name.mcds[each.key].result)
  maintenance_configuration_id = each.value.id

  dynamic "filter" {
    for_each = var.dynamic_scope_assignment.filter[*]
    content {
      locations       = filter.value.locations
      os_types        = filter.value.os_types
      resource_groups = filter.value.resource_groups
      resource_types  = filter.value.resource_types
      tag_filter      = filter.value.tag_filter

      dynamic "tags" {
        for_each = filter.value.tags
        content {
          tag    = tags.value.key
          values = tags.value.value
        }
      }
    }
  }
}
