resource "azurerm_management_group_policy_assignment" "UpdateCheckWindows" {
  for_each             = var.auto_assessment_enabled ? local.mg_assignment_scopes : []
  name                 = "WindowsVMUpdatesChecks"
  display_name         = "Configure periodic checking for missing updates on Windows VMs"
  description          = "Configure auto-assessment (every 24 hours) for OS updates on native Azure virtual machines. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode."
  management_group_id  = each.value
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15" # [Preview]: Configure periodic checking for missing system updates on azure virtual machines

  not_scopes = var.auto_assessment_exclusions

  identity {
    type = "SystemAssigned"
  }

  metadata = jsonencode({
    Category = "Update Management Center"
  })

  parameters = jsonencode({
    osType = { "value" = "Windows" }
  })
}

resource "azurerm_management_group_policy_assignment" "UpdateCheckLinux" {
  for_each             = var.auto_assessment_enabled ? local.mg_assignment_scopes : []
  name                 = "LinuxVMUpdatesChecks"
  display_name         = "Configure periodic checking for missing updates on Linux VMs"
  description          = "Configure auto-assessment (every 24 hours) for OS updates on native Azure virtual machines. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode."
  management_group_id  = each.value
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15" # [Preview]: Configure periodic checking for missing system updates on azure virtual machines

  not_scopes = var.auto_assessment_exclusions

  identity {
    type = "SystemAssigned"
  }

  metadata = jsonencode({
    Category = "Update Management Center"
  })

  parameters = jsonencode({
    osType = { "value" = "Linux" }
  })
}

resource "azurerm_subscription_policy_assignment" "UpdateCheckWindows" {
  for_each             = var.auto_assessment_enabled ? local.subscriptions_assignment_scopes : []
  name                 = "WindowsVMUpdatesChecks"
  display_name         = "Configure periodic checking for missing updates on Windows VMs"
  description          = "Configure auto-assessment (every 24 hours) for OS updates on native Azure virtual machines. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode."
  subscription_id      = each.value
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15"
  not_scopes           = var.auto_assessment_exclusions

  identity {
    type = "SystemAssigned"
  }

  metadata = jsonencode({
    Category = "Update Management Center"
  })

  parameters = jsonencode({
    osType = { "value" = "Windows" }
  })
}

resource "azurerm_subscription_policy_assignment" "UpdateCheckLinux" {
  for_each             = var.auto_assessment_enabled ? local.subscriptions_assignment_scopes : []
  name                 = "LinuxVMUpdatesChecks"
  display_name         = "Configure periodic checking for missing updates on Linux VMs"
  description          = "Configure auto-assessment (every 24 hours) for OS updates on native Azure virtual machines. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode."
  subscription_id      = each.value
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15" # [Preview]: Configure periodic checking for missing system updates on azure virtual machines

  not_scopes = var.auto_assessment_exclusions

  identity {
    type = "SystemAssigned"
  }

  metadata = jsonencode({
    Category = "Update Management Center"
  })

  parameters = jsonencode({
    osType = { "value" = "Linux" }
  })
}

resource "azurerm_resource_group_policy_assignment" "UpdateCheckWindows" {
  for_each             = var.auto_assessment_enabled ? local.resource_group_assignment_scopes : []
  name                 = "WindowsVMUpdatesChecks"
  display_name         = "Configure periodic checking for missing updates on Windows VMs"
  description          = "Configure auto-assessment (every 24 hours) for OS updates on native Azure virtual machines. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode."
  resource_group_id    = each.value
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15"
  not_scopes           = var.auto_assessment_exclusions

  identity {
    type = "SystemAssigned"
  }

  metadata = jsonencode({
    Category = "Update Management Center"
  })

  parameters = jsonencode({
    osType = { "value" = "Windows" }
  })
}

resource "azurerm_resource_group_policy_assignment" "UpdateCheckLinux" {
  for_each             = var.auto_assessment_enabled ? local.resource_group_assignment_scopes : []
  name                 = "LinuxVMUpdatesChecks"
  display_name         = "Configure periodic checking for missing updates on Linux VMs"
  description          = "Configure auto-assessment (every 24 hours) for OS updates on native Azure virtual machines. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode."
  resource_group_id    = each.value
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15" # [Preview]: Configure periodic checking for missing system updates on azure virtual machines

  not_scopes = var.auto_assessment_exclusions

  identity {
    type = "SystemAssigned"
  }

  metadata = jsonencode({
    Category = "Update Management Center"
  })

  parameters = jsonencode({
    osType = { "value" = "Linux" }
  })
}

resource "azurerm_resource_policy_assignment" "UpdateCheckWindows" {
  for_each             = var.auto_assessment_enabled ? local.virtual_machines_assignment_scopes : []
  name                 = "WindowsVMUpdatesChecks"
  display_name         = "Configure periodic checking for missing updates on Windows VMs"
  description          = "Configure auto-assessment (every 24 hours) for OS updates on native Azure virtual machines. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode."
  resource_id          = each.value
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15"
  not_scopes           = var.auto_assessment_exclusions

  identity {
    type = "SystemAssigned"
  }

  metadata = jsonencode({
    Category = "Update Management Center"
  })

  parameters = jsonencode({
    osType = { "value" = "Windows" }
  })
}

resource "azurerm_resource_policy_assignment" "UpdateCheckLinux" {
  for_each             = var.auto_assessment_enabled ? local.virtual_machines_assignment_scopes : []
  name                 = "LinuxVMUpdatesChecks"
  display_name         = "Configure periodic checking for missing updates on Linux VMs"
  description          = "Configure auto-assessment (every 24 hours) for OS updates on native Azure virtual machines. You can control the scope of assignment according to machine subscription, resource group, location or tag. Learn more about this for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode."
  resource_id          = each.value
  location             = var.location
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15" # [Preview]: Configure periodic checking for missing system updates on azure virtual machines

  not_scopes = var.auto_assessment_exclusions

  identity {
    type = "SystemAssigned"
  }

  metadata = jsonencode({
    Category = "Update Management Center"
  })

  parameters = jsonencode({
    osType = { "value" = "Linux" }
  })
}
