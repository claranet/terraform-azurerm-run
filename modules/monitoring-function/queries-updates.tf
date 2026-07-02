locals {
  log_queries_updates = {
    update_center_success = {
      MetricName = "fame.azure.update_center.updates_status"
      MetricType = "gauge"
      QueryType  = "resource_graph"
      Query      = <<EOQ
        patchinstallationresources
        | where type == 'microsoft.compute/virtualmachines/patchinstallationresults'
        | extend azure_resource_name = tostring(split(id, '/')[8])
        | extend last_updated=todatetime(properties.lastModifiedDateTime)
        | where last_updated > ago(1d)
        | summarize last_updated = arg_max(last_updated, status=tolower(properties.status))
            by
            subscription_id=subscriptionId,
            azure_resource_name,
            azure_resource_group_name=resourceGroup,
            metric_value = 1,
            timestamp = now()
      EOQ
    }

    update_center_missing_updates = {
      MetricName = "fame.azure.update_center.missing_updates"
      MetricType = "gauge"
      QueryType  = "resource_graph"
      Query      = <<EOQ
        patchassessmentresources
        | where type == 'microsoft.compute/virtualmachines/patchassessmentresults'
        | extend id_parts  = split(id, '/')
        | extend subscription_id = tostring(id_parts[2])
        | extend azure_resource_group_name = tostring(id_parts[4])
        | extend azure_resource_name = tostring(id_parts[8])
        | extend ts=todatetime(properties.lastModifiedDateTime)
        | mv-expand bagexpansion=array patchs=properties.availablePatchCountByClassification
        | project
            timestamp=ts,
            metric_value=patchs[1],
            classification=patchs[0],
            subscription_id,
            azure_resource_name,
            azure_resource_group_name
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

    automation_updates_missing_updates = {
      MetricName = "fame.azure.automation_update.missing_updates"
      MetricType = "gauge"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        Heartbeat
        | where TimeGenerated > ago(12h) and OSType == "Linux" and notempty(Computer)
        | summarize arg_max(TimeGenerated, Solutions, Computer, ResourceId, ComputerEnvironment, VMUUID) by SourceComputerId
        | where Solutions has "updates"
        | join kind=leftouter
            (
            Update
            | where TimeGenerated > ago(5h) and OSType == "Linux" and SourceComputerId in ((Heartbeat
                | where TimeGenerated > ago(12h) and OSType == "Linux" and notempty(Computer)
                | summarize arg_max(TimeGenerated, Solutions) by SourceComputerId
                | where Solutions has "updates"
                | distinct SourceComputerId))
            | summarize hint.strategy=partitioned arg_max(TimeGenerated, UpdateState, Classification, Product, Computer, ComputerEnvironment) by SourceComputerId, Product, ProductArch, ResourceGroup, SubscriptionId
                | project
                    SourceComputerId,
                    Computer,
                    ComputerEnvironment,
                    ResourceGroup,
                    SubscriptionId,
                    os_type="linux",
                    class= iff(Classification has "Critical" and UpdateState =~ "Needed", "critical", iff(Classification has "Security" and UpdateState =~ "Needed", "security", iff(Classification !has "Critical" and Classification !has "Security" and UpdateState =~ "Needed", "other", "")))
            )
            on SourceComputerId
            | where class != ""
        | union(
            Heartbeat
            | where TimeGenerated > ago(12h) and OSType =~ "Windows" and notempty(Computer)
            | summarize arg_max(TimeGenerated, Solutions, Computer, ResourceId, ComputerEnvironment, VMUUID) by SourceComputerId
            | where Solutions has "updates"
            | join kind=leftouter
                (
                Update
                | where TimeGenerated > ago(14h) and OSType != "Linux" and SourceComputerId in ((Heartbeat
                    | where TimeGenerated > ago(12h) and OSType =~ "Windows" and notempty(Computer)
                    | summarize arg_max(TimeGenerated, Solutions) by SourceComputerId
                    | where Solutions has "updates"
                    | distinct SourceComputerId))
                | summarize hint.strategy=partitioned arg_max(TimeGenerated, UpdateState, Classification, Title, Optional, Approved, Computer, ComputerEnvironment) by Computer, SourceComputerId, UpdateID, ResourceGroup, SubscriptionId
                | project
                    SourceComputerId,
                    Computer,
                    ComputerEnvironment,
                    ResourceGroup,
                    SubscriptionId,
                    os_type="windows",
                    class= iff(Classification has "Critical" and UpdateState =~ "Needed" and Approved != false, "critical", iff(Classification has "Security" and UpdateState =~ "Needed" and Approved != false, "security", iff(Classification !has "Critical" and Classification !has "Security" and UpdateState =~ "Needed" and Optional == false and Approved != false, "other", "")))
                )
                on SourceComputerId)
            | where class != ""
            | summarize
                timestamp=max(TimeGenerated),
                metric_value=count()
                by
                classification=class,
                azure_resource_name=Computer,
                azure_resource_group=ResourceGroup,
                subscription_id=SubscriptionId,
                os_type
EOQ
    }
  }
}
