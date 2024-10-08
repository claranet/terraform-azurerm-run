resource "azurerm_monitor_data_collection_rule" "main" {
  name                = local.name
  resource_group_name = var.resource_group_name
  location            = var.location

  destinations {
    log_analytics {
      workspace_resource_id = var.log_analytics_workspace_id
      name                  = "default-workspace"
    }
    azure_monitor_metrics {
      name = "default-azure-monitor-metrics"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["default-azure-monitor-metrics"]
  }

  data_flow {
    streams      = ["Microsoft-Perf", "Microsoft-Event", "Microsoft-Syslog"]
    destinations = ["default-workspace"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor Information(_Total)\\% Processor Time",
        "\\Processor Information(_Total)\\% Privileged Time",
        "\\Processor Information(_Total)\\% User Time",
        "\\Processor Information(_Total)\\Processor Frequency",
        "\\System\\Processes",
        "\\Process(_Total)\\Thread Count",
        "\\Process(_Total)\\Handle Count",
        "\\System\\System Up Time",
        "\\System\\Context Switches/sec",
        "\\System\\Processor Queue Length",
        "\\Memory\\% Committed Bytes In Use",
        "\\Memory\\Available Bytes",
        "\\Memory\\Committed Bytes",
        "\\Memory\\Cache Bytes",
        "\\Memory\\Pool Paged Bytes",
        "\\Memory\\Pool Nonpaged Bytes",
        "\\Memory\\Pages/sec",
        "\\Memory\\Page Faults/sec",
        "\\Process(_Total)\\Working Set",
        "\\Process(_Total)\\Working Set - Private",
        "\\LogicalDisk(_Total)\\% Disk Time",
        "\\LogicalDisk(_Total)\\% Disk Read Time",
        "\\LogicalDisk(_Total)\\% Disk Write Time",
        "\\LogicalDisk(_Total)\\% Idle Time",
        "\\LogicalDisk(_Total)\\Disk Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Transfers/sec",
        "\\LogicalDisk(_Total)\\Disk Reads/sec",
        "\\LogicalDisk(_Total)\\Disk Writes/sec",
        "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
        "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
        "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
        "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
        "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
        "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
        "\\LogicalDisk(_Total)\\% Free Space",
        "\\LogicalDisk(_Total)\\Free Megabytes",
        "\\Network Interface(*)\\Bytes Total/sec",
        "\\Network Interface(*)\\Bytes Sent/sec",
        "\\Network Interface(*)\\Bytes Received/sec",
        "\\Network Interface(*)\\Packets/sec",
        "\\Network Interface(*)\\Packets Sent/sec",
        "\\Network Interface(*)\\Packets Received/sec",
        "\\Network Interface(*)\\Packets Outbound Errors",
        "\\Network Interface(*)\\Packets Received Errors",
      ]
      name = "default-datasource-perfcounter"
    }

    windows_event_log {
      streams = ["Microsoft-WindowsEvent"]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2)]]",
        "System!*[System[(Level=1 or Level=2)]]"
      ]
      name = "default-datasource-wineventlog"
    }

    syslog {
      facility_names = var.syslog_facilities_names
      log_levels     = var.syslog_levels
      name           = "default-datasource-syslog"
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}

moved {
  from = azurerm_monitor_data_collection_rule.dcr
  to   = azurerm_monitor_data_collection_rule.main
}