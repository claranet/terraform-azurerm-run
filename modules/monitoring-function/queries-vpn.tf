locals {
  log_queries_vpn = {
    vpn_successful_ike_diags = {
      MetricName = "fame.azure.virtual_network_gateway.ike_event_success"
      MetricType = "gauge"
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
      Query      = <<EOQ
        AzureMetrics
        | where MetricName == "TunnelTotalFlowCount"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=sum(Total) by timestamp=bin(TimeGenerated, 1m), azure_resource_name=Resource, azure_resource_group=ResourceGroup, subscription_id=SubscriptionId
      EOQ
    }
  }
}
