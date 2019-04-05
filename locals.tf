locals {
  default_tags = {
    env   = "${var.environment}"
    stack = "${var.stack}"
  }

  name_prefix = "${var.name_prefix != "" ? format("%s-", var.name_prefix) : ""}"

  storage_default_name_long = "${replace(format("st%s%s%s%s", var.environment, var.client_name, var.stack, coalesce(var.storage_account_name_suffix, var.name_prefix)), "/[._-]/", "")}"
  storage_default_name      = "${substr(local.storage_default_name_long, 0, length(local.storage_default_name_long) > 24 ? 23 : -1)}"
}
