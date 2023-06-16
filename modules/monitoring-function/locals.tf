locals {
  extra_dimensions = join(",", [for k, v in merge(local.default_tags, var.metrics_extra_dimensions) : format("%s=%s", k, v)])

  log_queries = merge(
    local.log_queries_appgw,
    local.log_queries_backup,
    local.log_queries_frontdoor,
    local.log_queries_updates,
    local.log_queries_vpn,
  )
}
