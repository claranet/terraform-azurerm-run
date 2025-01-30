resource "azurerm_maintenance_configuration" "main" {
  for_each = { for config in var.maintenance_configurations : config.configuration_name => config }

  name                = join("", compact([var.name_prefix, each.key]))
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
  for_each                     = var.dynamic_scope_assignment.enabled ? { for config in var.maintenance_configurations : config.configuration_name => config } : {}
  name                         = join("", compact([var.dynamic_scope_assignment.name_prefix, each.key]))
  maintenance_configuration_id = azurerm_maintenance_configuration.main[each.key].id

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
