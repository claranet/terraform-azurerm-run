locals {
  log_queries_appgw = {
    application_gateway_instances = {
      MetricName = "fame.azure.application_gateway.instances"
      MetricType = "gauge"
      Query      = <<EOQ
        AzureDiagnostics
        | where ResourceType == "APPLICATIONGATEWAYS" and OperationName == "ApplicationGatewayAccess"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=dcount(instanceId_s) by timestamp=bin(TimeGenerated, 1m), azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
      EOQ
    }
  }
}
