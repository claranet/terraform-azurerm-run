locals {
  log_queries_heartbeat = {
    heartbeat = {
      MetricName = "fame.azure.heartbeat"
      QueryType  = "log_analytics"
      Query      = <<EOQ
        print timestamp=now(), metric_value=1
      EOQ
    }
  }
}
