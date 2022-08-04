# Log Analytics
resource "azurerm_log_analytics_workspace" "log_workspace" {
  name = coalesce(
    var.log_analytics_workspace_custom_name,
    local.log_analytics_name,
  )
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = var.log_analytics_workspace_sku
  retention_in_days = var.log_analytics_workspace_retention_in_days

  tags = merge(
    local.default_tags,
    var.extra_tags,
    var.log_analytics_workspace_extra_tags,
  )
}

data "azurerm_subscription" "current" {}

resource "null_resource" "log_workspace_config" {
  provisioner "local-exec" {
    command = <<EOC
      $accessToken = az account get-access-token -s ${data.azurerm_subscription.current.subscription_id} --query "accessToken" -o tsv
      $accountId = az account show -s ${data.azurerm_subscription.current.subscription_id} --query "user.name" -o tsv
      Disconnect-AzAccount
      Connect-AzAccount -AccessToken $accessToken -AccountId $accountId -Force
      Get-AzSubscription -SubscriptionId ${data.azurerm_subscription.current.subscription_id} | Set-AzContext -Name "terraform-${data.azurerm_subscription.current.subscription_id}" -Force

      if("${var.log_analytics_workspace_enable_iis_logs}" -eq "true") {
        Enable-AzOperationalInsightsIISLogCollection -ResourceGroupName ${var.resource_group_name} -WorkspaceName ${azurerm_log_analytics_workspace.log_workspace.name}
      }
      else {
        Disable-AzOperationalInsightsIISLogCollection -ResourceGroupName ${var.resource_group_name} -WorkspaceName ${azurerm_log_analytics_workspace.log_workspace.name}
      }
EOC

    interpreter = ["pwsh", "-c"]
  }

  triggers = {
    iislogs   = var.log_analytics_workspace_enable_iis_logs
    workspace = azurerm_log_analytics_workspace.log_workspace.name
  }

  depends_on = [azurerm_log_analytics_workspace.log_workspace]
}
