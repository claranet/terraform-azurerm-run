data "azurerm_subscription" "current" {}

data "external" "log_analytics_update_solution" {
  program = [
    "az",
    "resource",
    "list",
    "--name",
    "Updates(${split("/", var.log_analytics_workspace_id)[8]})",
    "--location",
    var.location_cli,
    "--resource-group",
    var.resource_group_name,
    "--subscription",
    data.azurerm_subscription.current.subscription_id,
    "-o",
    "json",
    "--query",
    "{ \"id\": [0].id }"
  ]
}
