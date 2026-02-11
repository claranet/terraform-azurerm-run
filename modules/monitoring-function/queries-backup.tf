locals {
  log_queries_backup = {
    file_shares_backup = {
      MetricName = "fame.azure.backup.file_share"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        AddonAzureBackupJobs
        | union (AzureDiagnostics
            | where Category == "AddonAzureBackupJobs")
        | extend id_parts  = split(ResourceId, '/')
        | extend subscription_id = id_parts[2]
        | extend recovery_vault_name = id_parts[8]
        | extend storage_parts = split(coalesce(BackupItemUniqueId, column_ifexists("BackupItemUniqueId_s", "")), ';')
        | extend azure_resource_group_name = storage_parts[3]
        | extend azure_resource_name = storage_parts[4]
        | extend share_backup_id = storage_parts[5]
        | extend metric_value = iff(coalesce(JobFailureCode, column_ifexists("JobFailureCode_s", "")) == "Success", 1, 0)
        | where TimeGenerated > ago(1d)
        | where coalesce(JobOperation, column_ifexists("JobOperation_s", "")) == "Backup"
        | where coalesce(BackupManagementType, column_ifexists("BackupManagementType_s", "")) == "AzureStorage"
        | summarize arg_max(TimeGenerated,*) by coalesce(JobUniqueId, column_ifexists("JobUniqueId_g", ""))
        | project timestamp=TimeGenerated, subscription_id, recovery_vault_name, azure_resource_group_name, azure_resource_name, share_backup_id, metric_value
      EOQ
    }

    virtual_machines_backup = {
      MetricName = "fame.azure.backup.vm"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        AddonAzureBackupJobs
        | union (AzureDiagnostics
            | where Category == "AddonAzureBackupJobs")
        | extend id_parts  = split(ResourceId, '/')
        | extend subscription_id = id_parts[2]
        | extend recovery_vault_name = id_parts[8]
        | extend vm_parts = split(coalesce(BackupItemUniqueId, column_ifexists("BackupItemUniqueId_s", "")), ';')
        | extend azure_resource_group_name = vm_parts[3]
        | extend azure_resource_name = vm_parts[4]
        | extend metric_value = iff(coalesce(JobFailureCode, column_ifexists("JobFailureCode_s", "")) == "Success", 1, 0)
        | where TimeGenerated > ago(1d)
        | where coalesce(JobOperation, column_ifexists("JobOperation_s", "")) == "Backup"
        | where coalesce(BackupManagementType, column_ifexists("BackupManagementType_s", "")) == "IaaSVM"
        | summarize arg_max(TimeGenerated,*) by coalesce(JobUniqueId, column_ifexists("JobUniqueId_g", ""))
        | project timestamp=TimeGenerated, subscription_id, recovery_vault_name, azure_resource_group_name, azure_resource_name, metric_value
      EOQ
    }

    postgresql_backup = {
      MetricName = "fame.azure.backup.postgresql"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        AzureMetrics
        | where ResourceProvider == "MICROSOFT.DBFORPOSTGRESQL"
        | where MetricName == "backup_storage_used"
        | extend id_parts = split(ResourceId, '/')
        | extend subscription_id = tostring(id_parts[2])
        | extend azure_resource_group_name = tostring(id_parts[4])
        | extend azure_resource_name = Resource
        | summarize LastBackupTime = max(TimeGenerated) by subscription_id, azure_resource_group_name, azure_resource_name
        | extend metric_value = iff(LastBackupTime >= ago(1h), 1, 0)
        | project timestamp=LastBackupTime, subscription_id, azure_resource_group_name, azure_resource_name, metric_value
      EOQ
    }
  }
}
