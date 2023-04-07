locals {
  log_queries_updates = {
    update_center_success = {
      MetricName = "fame.azure.update_center.updates_status"
      MetricType = "gauge"
      QueryType  = "resource_graph"
      Query      = <<EOQ
        patchinstallationresources
        | where type == 'microsoft.compute/virtualmachines/patchinstallationresults'
        | extend id_parts  = split(id, '/')
        | extend subscription_id = tostring(id_parts[2])
        | extend azure_resource_group_name = tostring(id_parts[4])
        | extend azure_resource_name = tostring(id_parts[8])
        | extend ts=todatetime(properties.lastModifiedDateTime)
        | where ts > ago(15m)
        | summarize timestamp = arg_max(ts, status=tolower(properties.status))
            by
            subscription_id,
            azure_resource_name,
            azure_resource_group_name,
            metric_value = 1
      EOQ
    }

    automation_updates_status = {
      MetricName = "fame.azure.automation_update.updates_status"
      MetricType = "gauge"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        UpdateRunProgress
        | where InstallationStatus != "NotStarted"
        | where TimeGenerated > ago(15m)
        | summarize arg_max(TimeGenerated, InstallationStatus) by UpdateId, Computer, ResourceGroup, SubscriptionId
        | project
            timestamp=TimeGenerated,
            metric_value=1,
            azure_resource_name=Computer,
            resource_group=tolower(ResourceGroup),
            subscription_id=SubscriptionId,
            update_id=UpdateId,
            status=tolower(InstallationStatus)
EOQ
    }
  }
}
