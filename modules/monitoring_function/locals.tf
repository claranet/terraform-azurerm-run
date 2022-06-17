locals {
  extra_dimensions = join(",", [for k, v in var.metrics_extra_dimensions : format("%s=%s", k, v)])

  log_queries = {
    application_gateway_instances : {
      MetricName : "fame.azure.application_gateway.instances"
      MetricType : "gauge"
      Query : <<EOQ
        AzureDiagnostics
        | where ResourceType == "APPLICATIONGATEWAYS" and OperationName == "ApplicationGatewayAccess"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=dcount(instanceId_s) by timestamp=bin(TimeGenerated, 1m), azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
      EOQ
    },
    file_shares_backup : {
      MetricName : "fame.azure.backup.file_share"
      MetricType : "gauge"
      Query : <<EOQ
        AddonAzureBackupJobs
        | union (AzureDiagnostics
            | where Category == "AddonAzureBackupJobs")
        | extend id_parts  = split(ResourceId, '/')
        | extend subscription_id = id_parts[2]
        | extend recovery_vault_name = id_parts[8]
        | extend storage_parts = split(coalesce(BackupItemUniqueId, BackupItemUniqueId_s), ';')
        | extend azure_resource_group_name = storage_parts[3]
        | extend azure_resource_name = storage_parts[4]
        | extend share_backup_id = storage_parts[5]
        | extend metric_value = iff(coalesce(JobFailureCode, JobFailureCode_s) == "Success", 1, 0)
        | where TimeGenerated > ago(1d)
        | where coalesce(JobOperation, JobOperation_s) == "Backup"
        | where coalesce(BackupManagementType, BackupManagementType_s) == "AzureStorage"
        | summarize arg_max(TimeGenerated,*) by coalesce(JobUniqueId, JobUniqueId_g)
        | project timestamp=TimeGenerated, subscription_id, recovery_vault_name, azure_resource_group_name, azure_resource_name, share_backup_id, metric_value
      EOQ
    },
    virtual_machines_backup : {
      MetricName : "fame.azure.backup.vm"
      MetricType : "gauge"
      Query : <<EOQ
        AddonAzureBackupJobs
        | union (AzureDiagnostics
            | where Category == "AddonAzureBackupJobs")
        | extend id_parts  = split(ResourceId, '/')
        | extend subscription_id = id_parts[2]
        | extend recovery_vault_name = id_parts[8]
        | extend vm_parts = split(coalesce(BackupItemUniqueId, BackupItemUniqueId_s), ';')
        | extend azure_resource_group_name = vm_parts[3]
        | extend azure_resource_name = vm_parts[4]
        | extend metric_value = iff(coalesce(JobFailureCode, JobFailureCode_s) == "Success", 1, 0)
        | where TimeGenerated > ago(1d)
        | where coalesce(JobOperation, JobOperation_s) == "Backup"
        | where coalesce(BackupManagementType, BackupManagementType_s) == "IaaSVM"
        | summarize arg_max(TimeGenerated,*) by coalesce(JobUniqueId, JobUniqueId_g)
        | project timestamp=TimeGenerated, subscription_id, recovery_vault_name, azure_resource_group_name, azure_resource_name, metric_value
      EOQ
    },
    vpn_successful_ike_diags : {
      MetricName : "fame.azure.virtual_network_gateway.ike_event_success"
      MetricType : "gauge"
      Query : <<EOQ
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
    },
    vpn_tunnel_total_flow_count : {
      MetricName : "fame.azure.virtual_network_gateway.total_flow_count"
      MetricType : "gauge"
      Query : <<EOQ
        AzureMetrics
        | where MetricName == "TunnelTotalFlowCount"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=sum(Total) by timestamp=bin(TimeGenerated, 1m), azure_resource_name=Resource, azure_resource_group=ResourceGroup, subscription_id=SubscriptionId
      EOQ
    },
    frontdoor_response_status : {
      MetricName : "fame.azure.frontdoor.response_status"
      MetricType : "gauge"
      Query : <<EOQ
        AzureDiagnostics
        | where ResourceProvider == "MICROSOFT.CDN"
        | where Category == "FrontDoorAccessLog"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=count() by timestamp=bin(TimeGenerated, 1m), http_status_code=tostring(toint(httpStatusCode_d)), azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
        | order by timestamp desc
      EOQ
    },

    frontdoor_probe_response_status : {
      MetricName : "fame.azure.frontdoor.probe_response_status"
      MetricType : "gauge"
      Query : <<EOQ
        AzureDiagnostics
        | where ResourceProvider == "MICROSOFT.CDN"
        | where Category == "FrontDoorHealthProbeLog"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=count() by timestamp=bin(TimeGenerated, 1m), result=(result_s), http_status_code=tostring(toint(httpStatusCode_d)), origin_name=(originName_s),azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
        | order by timestamp desc
      EOQ
    },

    frontdoor_waf_actions : {
      MetricName : "fame.azure.frontdoor.waf_actions"
      MetricType : "gauge"
      Query : <<EOQ
        AzureDiagnostics
        | where ResourceProvider == "MICROSOFT.CDN"
        | where Category == "FrontDoorWebApplicationFirewallLog"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=count() by timestamp=bin(TimeGenerated, 1m), action=tolower(action_s), policy=(policy_s), host=(host_s), azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
        | order by timestamp desc
      EOQ
    },

    frontdoor_cache_hit_rate : {
      MetricName : "fame.azure.frontdoor.cache_hit_rate"
      MetricType : "gauge"
      Query : <<EOQ
        AzureDiagnostics 
        | where Category == "FrontDoorAccessLog"
        | where TimeGenerated > ago(20m)
        | summarize metric_value = tostring(todouble(countif(cacheStatus_s == "HIT" or cacheStatus_s == "REMOTE_HIT")) / count() * 100) by timestamp=bin(TimeGenerated, 1m), endpoint=endpoint_s, azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
        | order by timestamp desc
      EOQ
    },
  }
}
