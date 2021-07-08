locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  extra_dimensions = join(",", [for k,v in var.metrics_extra_dimensions: format("%s=%s", k, v)])

  log_queries = {
    application_gateway_instances: {
      MetricName: "fame.azure.application_gateway.instances"
      MetricType: "gauge"
      Query: <<EOQ
        AzureDiagnostics
        | where ResourceType == "APPLICATIONGATEWAYS" and OperationName == "ApplicationGatewayAccess"
        | summarize metric_value=dcount(instanceId_s) by timestamp=bin(TimeGenerated, 1m), azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
      EOQ
    },
    file_shares_backup: {
      MetricName: "fame.azure.backup.vm"
      MetricType: "gauge"
      Query: <<EOQ
        AddonAzureBackupJobs
        | extend id_parts  = split(ResourceId, '/')
        | extend subscription_id = id_parts[2]
        | extend recovery_vault_name = id_parts[8]
        | extend storage_parts = split(BackupItemUniqueId, ';')
        | extend azure_resource_group_name = storage_parts[3]
        | extend azure_resource_name = storage_parts[4]
        | extend share_backup_id = storage_parts[5]
        | extend metric_value = iff(JobFailureCode == "Success", 1, 0)
        | where TimeGenerated > ago(1d)
        | where JobOperation == "Backup"
        | where BackupManagementType == "AzureStorage"
        | summarize arg_max(TimeGenerated,*) by JobUniqueId
        | project timestamp=TimeGenerated, subscription_id, recovery_vault_name, azure_resource_group_name, azure_resource_name, share_backup_id, metric_value
      EOQ
    },
    virtual_machines_backup: {
      MetricName: "fame.azure.backup.vm"
      MetricType: "gauge"
      Query: <<EOQ
        AddonAzureBackupJobs
        | extend id_parts  = split(ResourceId, '/')
        | extend subscription_id = id_parts[2]
        | extend recovery_vault_name = id_parts[8]
        | extend vm_parts = split(BackupItemUniqueId, ';')
        | extend azure_resource_group_name = vm_parts[3]
        | extend azure_resource_name = vm_parts[4]
        | extend metric_value = iff(JobFailureCode == "Success", 1, 0)
        | where TimeGenerated > ago(1d)
        | where JobOperation == "Backup"
        | where BackupManagementType == "IaaSVM"
        | summarize arg_max(TimeGenerated,*) by JobUniqueId
        | project timestamp=TimeGenerated, subscription_id, recovery_vault_name, azure_resource_group_name, azure_resource_name, metric_value
      EOQ
    },
    vpn_successful_ike_diags: {
      MetricName: "fame.azure.virtual_network_gateway.ike_event_success"
      MetricType: "gauge"
      Query: <<EOQ
        AzureDiagnostics
        | where Category == "IKEDiagnosticLog"
        | where OperationName == "IKELogEvent"
        | parse Message with * "Messid : " MessageId
        | where substring(Message, 1, 4) == "SEND"
        | join (AzureDiagnostics
            | where Category == "IKEDiagnosticLog"
            | where OperationName == "IKELogEvent"
            | parse Message with * "Messid : " MessageId
            | where substring(Message, 1, 4) == "RECV") on $left.MessageId == $right.MessageId  and $left.ResourceId == $right.ResourceId
        | summarize metric_value=dcount(MessageId) by timestamp=bin(TimeGenerated, 1m), azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
      EOQ
    },
  }
}
