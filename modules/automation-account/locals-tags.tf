locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}

  merged_tags = merge(local.default_tags, var.extra_tags, var.automation_account_extra_tags)

  # Automation Account Azure resource can have only 15 tags maximum
  truncated_tags = {
    for key in try(chunklist(keys(local.merged_tags), 14)[0], []) : key => lookup(local.merged_tags, key)
  }

  # We keep the 14 first tags, serialize all the others in a 15th one (JSON encoded)
  curtailed_tags = merge(
    local.truncated_tags,
    try({ "extra_tags" = jsonencode({ for key in slice(keys(local.merged_tags), 14, length(local.merged_tags)) : key => lookup(local.merged_tags, key) }) }, {})
  )
}
