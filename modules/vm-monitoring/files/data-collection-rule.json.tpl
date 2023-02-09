{
  "location": "${location}",
  "tags": ${tags},
  "properties": {
    "dataFlows": [
      {
        "destinations": [
          "azureMonitorMetrics-default"
        ],
        "streams": [
          "Microsoft-InsightsMetrics"
        ]
      },
      {
        "destinations": [
          "centralWorkspace"
        ],
        "streams": [
          "Microsoft-Perf",
          "Microsoft-Event",
          "Microsoft-Syslog"
        ]
      }
    ],
    "dataSources": {
      "performanceCounters": [
        {
          "counterSpecifiers": [
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
            "\\Network Interface(*)\\Packets Received Errors"
          ],
          "name": "perfCounterDataSource",
          "samplingFrequencyInSeconds": 60,
          "scheduledTransferPeriod": "PT1M",
          "streams": [
            "Microsoft-Perf",
            "Microsoft-InsightsMetrics"
          ]
        }
      ],
      "syslog": [
        {
          "facilityNames": ${syslog_facility_names},
          "logLevels": ${syslog_levels},
          "name": "sysLogsDataSource",
          "streams": [
            "Microsoft-Syslog"
          ]
        }
      ],
      "windowsEventLogs": [
        {
          "name": "eventLogsDataSource",
          "scheduledTransferPeriod": "PT5M",
          "streams": [
            "Microsoft-Event"
          ],
          "xPathQueries": [
            "Application!*[System[(Level=1 or Level=2)]]",
            "System!*[System[(Level=1 or Level=2)]]"
          ]
        }
      ]
    },
    "destinations": {
      "azureMonitorMetrics": {
        "name": "azureMonitorMetrics-default"
      },
      "logAnalytics": [
        {
          "name": "centralWorkspace",
          "workspaceResourceId": "${log_analytics_workspace_id}"
        }
      ]
    },
  }
}
