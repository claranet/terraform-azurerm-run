locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}

  merged_tags = merge(local.default_tags, var.extra_tags, var.automation_account_extra_tags)

  truncated_tags = {
    for key in slice(keys(local.merged_tags), 0, length(local.merged_tags) >= 14 ? 14 : length(local.merged_tags)) : key => lookup(local.merged_tags, key)
  }
  curtailed_tags = length(local.merged_tags) >= 14 ? merge(local.truncated_tags, {
    "extra_tags" = jsonencode({ for key in slice(keys(local.merged_tags), 14, length(local.merged_tags)) : key => lookup(local.merged_tags, key) })
  }) : local.merged_tags
}
