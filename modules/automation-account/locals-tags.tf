locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}

  merged_tags = merge(local.default_tags, var.extra_tags, var.automation_account_extra_tags)
  chunked_tags_keys = chunklist(keys(local.merged_tags), 15)
  chunked_tags_values = chunklist(values(local.merged_tags), 15)
  chunked_tags = zipmap(local.chunked_tags_keys[0], local.chunked_tags_values[0])
}
