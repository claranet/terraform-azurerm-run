locals {
  log_queries_vpn = {
    vpn_successful_ike_diags = {
      MetricName = "fame.azure.virtual_network_gateway.ike_event_success"
      MetricType = "gauge"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        AzureDiagnostics
        | where Category == "IKEDiagnosticLog"
        | where OperationName == "IKELogEvent"
        | parse Message with * "Messid : " MessageId
        | where substring(Message, 1, 4) == "SEND"
        | where TimeGenerated > ago(20m)
        | join (AzureDiagnostics
            | where Category == "IKEDiagnosticLog"
            | where OperationName == "IKELogEvent"
            | parse Message with * "Messid : " MessageId
            | where substring(Message, 1, 4) == "RECV") on $left.MessageId == $right.MessageId  and $left.ResourceId == $right.ResourceId
        | summarize metric_value=dcount(MessageId) by timestamp=bin(TimeGenerated, 1m), azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
      EOQ
    }

    vpn_tunnel_total_flow_count = {
      MetricName = "fame.azure.virtual_network_gateway.total_flow_count"
      MetricType = "gauge"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        AzureMetrics
        | where MetricName == "TunnelTotalFlowCount"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=sum(Total) by timestamp=bin(TimeGenerated, 1m), azure_resource_name=Resource, azure_resource_group=ResourceGroup, subscription_id=SubscriptionId
      EOQ
    }

    vpn_tunnel_status = {
      MetricName = "fame.azure.virtual_network_gateway.tunnel_status"
      MetricType = "gauge"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        AzureDiagnostics
        | where Category == "TunnelDiagnosticLog"
        | where TimeGenerated > ago(20m)
        | extend status_int = case(status_s  == "Connected", 1, 0)
        | project timestamp=TimeGenerated, metric_value=status_int, status_s, ResourceGroup, SubscriptionId, Resource, remoteIP_s
      EOQ
    }
  }
}
