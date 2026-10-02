locals {
  log_queries_site_recovery = {
    replicated_items_health = {
      MetricName = "fame.azure.recoveryservices_vaults.replicated_items_health"
      MetricType = "gauge"
      QueryType  = "resource_graph"
      Query      = <<EOQ
        RecoveryServicesResources
        | where type =~ "microsoft.recoveryservices/vaults/replicationfabrics/replicationprotectioncontainers/replicationprotecteditems"
        | extend vault_name = extract(@"(?i)/vaults/([^/]+)", 1, id)
        | extend replication_health = tostring(properties.replicationHealth)
        | project
            timestamp = now(),
            metric_value = iff(replication_health =~ "Normal", 1, 0),
            subscription_id = subscriptionId,
            azure_resource_group_name = resourceGroup,
            azure_resource_name = tostring(properties.friendlyName),
            vault_name,
            protection_state = tostring(properties.protectionState),
            replication_health
      EOQ
    }
  }
}
