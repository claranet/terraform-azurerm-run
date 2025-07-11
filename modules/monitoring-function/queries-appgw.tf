locals {
  log_queries_appgw = {
    application_gateway_instances = {
      MetricName = "fame.azure.application_gateway.instances"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        AGWAccessLogs
        | union (AzureDiagnostics
            | where ResourceType == "APPLICATIONGATEWAYS" )
        | where OperationName == "ApplicationGatewayAccess"
        | extend id_parts  = split(coalesce(_ResourceId, column_ifexists("ResourceId", "")), '/')
        | extend subscription_id = tostring(id_parts[2])
        | extend azure_resource_group_name = tostring(id_parts[4])
        | extend azure_resource_name = tostring(id_parts[8])
        | where TimeGenerated > ago(20m)
        | summarize metric_value=dcount(coalesce(InstanceId, column_ifexists("instanceId_s", ""))) by timestamp=bin(TimeGenerated, 1m), azure_resource_name=azure_resource_name, azure_resource_group_name=azure_resource_group_name, subscription_id=subscription_id
      EOQ
    }
  }
}
