locals {
  log_queries_vpn = {
    vpn_successful_ike_diags = {
      MetricName = "fame.azure.virtual_network_gateway.ike_event_success"
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
      QueryType  = "log_analytics"
      Query      = <<EOQ
        AzureDiagnostics
        | where OperationName == "IKELogEvent"
        | where Message contains "Remote" and Message contains "[SEND]"
        | parse Message with * "Remote " remote_ip ":" *
        | summarize by remote_ip, azure_resource_group=ResourceGroup, subscription_id=SubscriptionId, azure_resource_name=Resource, timestamp=now()
        | join kind=leftouter (
          AzureDiagnostics
          | where Category == "TunnelDiagnosticLog"
          | where TimeGenerated > ago(90d)
          | extend status_int = case(status_s == "Connected", 1, 0)
          | summarize last_state_change=arg_max(TimeGenerated, metric_value=status_int) by remote_ip=remoteIP_s, azure_resource_group=ResourceGroup, subscription_id=SubscriptionId, azure_resource_name=Resource, timestamp=now()
        ) on $left.remote_ip == $right.remote_ip
        | project remote_ip, azure_resource_group, subscription_id, timestamp=now(),azure_resource_name, metric_value = case(isnull(last_state_change), 1, 1)
      EOQ
    }
  }
}
