# https://learn.microsoft.com/en-us/azure/update-center/manage-vms-programmatically?tabs=cli%2Crest

# Resource azurerm_maintenance_configuration does not support InGuestPatch scope.
# because not supported on API 2021-05-01.
resource "azapi_resource" "maintenance_configurations" {
  for_each  = { for config in var.maintenance_configurations : config.configuration_name => config }
  name      = "mc-${each.key}"
  parent_id = local.rg_id
  type      = "Microsoft.Maintenance/maintenanceConfigurations@2021-09-01-preview"
  body = jsonencode(
    {
      location = lower(var.location)
      properties = {
        namespace = null
        extensionProperties = {
          InGuestPatchMode = "User"
        }
        maintenanceScope = "InGuestPatch"
        maintenanceWindow = {
          startDateTime = each.value.start_date_time
          duration      = each.value.duration
          timeZone      = each.value.time_zone
          recurEvery    = each.value.recur_every
        }
        visibility = "Custom"
        installPatches = {
          rebootSetting = each.value.reboot_setting
          windowsParameters = {
            classificationsToInclude = each.value.windows_classifications_to_include
            kbNumbersToExclude       = each.value.windows_kb_ids_to_exclude
          }
          linuxParameters = {
            classificationsToInclude  = each.value.linux_classifications_to_include
            packageNameMasksToExclude = each.value.linux_package_names_to_exclude
          }
        }
      }
    }
  )
  tags                    = local.mc_tags
  response_export_values  = ["*"]
  ignore_missing_property = true
}
