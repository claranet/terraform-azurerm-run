locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}

  tags = merge(local.default_tags, var.extra_tags)

  # To avoid perpetual drift
  mc_tags = {
    for key, value in local.tags : lower(key) => value
  }
}
