locals {
  log_queries_automation = {
    automation_runbook_job = {
      MetricName = "fame.azure.automation.runbook_job"
      MetricType = "gauge"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        AzureDiagnostics
        | where ResourceProvider == "MICROSOFT.AUTOMATION"
        | where Category == "JobLogs"
        | extend id_parts = split(ResourceId, '/')
        | extend subscription_id = tostring(id_parts[2])
        | extend azure_resource_group_name = tostring(id_parts[4])
        | extend azure_resource_name = tostring(id_parts[8])
        | extend runbook_name = coalesce(RunbookName_s, column_ifexists("RunbookName_s", ""))
        | extend job_id = coalesce(JobId_g, column_ifexists("JobId_g", ""))
        | summarize arg_max(TimeGenerated, *) by runbook_name, job_id
        | extend metric_value = iff(ResultType == "Completed", 1, 0)
        | project timestamp=TimeGenerated, subscription_id, azure_resource_group_name, azure_resource_name, runbook_name, job_id, metric_value
      EOQ
    }
  }
}
