locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}

  merged_tags = merge(local.default_tags, var.extra_tags, var.automation_account_extra_tags)

  curtailed_tags = {
    for key in slice(keys(local.merged_tags), 0, length(local.merged_tags) >= 15 ? 15 : length(local.merged_tags)) : key => lookup(local.merged_tags, key)
  }
}
