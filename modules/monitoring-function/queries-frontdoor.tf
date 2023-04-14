locals {
  log_queries_frontdoor = {
    frontdoor_response_status = {
      MetricName = "fame.azure.frontdoor.response_status"
      MetricType = "gauge"
      Query      = <<EOQ
        AzureDiagnostics
        | where ResourceProvider == "MICROSOFT.CDN"
        | where Category == "FrontDoorAccessLog"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=count() by timestamp=bin(TimeGenerated, 1m), http_status_code=tostring(toint(httpStatusCode_d)), azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
        | order by timestamp desc
      EOQ
    }

    frontdoor_probe_response_status = {
      MetricName = "fame.azure.frontdoor.probe_response_status"
      MetricType = "gauge"
      Query      = <<EOQ
        AzureDiagnostics
        | where ResourceProvider == "MICROSOFT.CDN"
        | where Category == "FrontDoorHealthProbeLog"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=count() by timestamp=bin(TimeGenerated, 1m), result=(result_s), http_status_code=tostring(toint(httpStatusCode_d)), origin_name=(originName_s),azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
        | order by timestamp desc
      EOQ
    }

    frontdoor_waf_actions = {
      MetricName = "fame.azure.frontdoor.waf_actions"
      MetricType = "gauge"
      Query      = <<EOQ
        AzureDiagnostics
        | where ResourceProvider == "MICROSOFT.CDN"
        | where Category == "FrontDoorWebApplicationFirewallLog"
        | where TimeGenerated > ago(20m)
        | summarize metric_value=count() by timestamp=bin(TimeGenerated, 1m), action=tolower(action_s), policy=(policy_s), host=(host_s), azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
        | order by timestamp desc
      EOQ
    }

    frontdoor_cache_hit_rate = {
      MetricName = "fame.azure.frontdoor.cache_hit_rate"
      MetricType = "gauge"
      Query      = <<EOQ
        AzureDiagnostics
        | where Category == "FrontDoorAccessLog"
        | where TimeGenerated > ago(20m)
        | summarize metric_value = tostring(todouble(countif(cacheStatus_s == "HIT" or cacheStatus_s == "REMOTE_HIT")) / count() * 100) by timestamp=bin(TimeGenerated, 1m), endpoint=endpoint_s, azure_resource_name=Resource, azure_resource_group_name=ResourceGroup, subscription_id=SubscriptionId
        | order by timestamp desc
      EOQ
    }
  }
}
