# Unreleased

Added
  * AZ-837: Add Update Management Center

# v6.3.0 - 2022-12-09

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)
  * AZ-800: Automation account can only have 15 tags maximum
  * AZ-846: Bump diagnotics settings module

# v6.2.0 - 2022-09-09

Added:
  * [GH-3](https://github.com/claranet/terraform-azurerm-run-iaas/pull/3): Expose `storage_mode_type`, `cross_region_restore_enabled` and `soft_delete_enabled` vault variables

# v6.1.0 - 2022-08-05

Breaking
  * AZ-807: Use native Azure resource to create Data Collection Rule

Fixed
  * AZ-809: Update examples to fix CI with latest tflint rules

# v6.0.0 - 2022-05-20

Breaking
  * AZ-717: Minimum Terraform version required `v1.1`
  * AZ-717: Upgrade module to AzureRM provider `v3.0+`

# v5.1.0 - 2022-04-29

Added
  * AZ-685: Added `identity` variable for automation module

# v5.0.0 - 2022-03-11

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources

Added
  * AZ-615: Add an option to enable or disable default tags

Changed
  * AZ-589: Bump `diagnostics` module to latest `v5.0.0`

# v4.4.0 - 2021-11-23

Fixed
  * AZ-589: Avoid plan drift when specifying Diagnostic Settings categories

Changed
  * AZ-462: Add `log_analytics_workspace_link_enabled` to avoid `The "count" value depends on resource attributes that cannot be determined` on automation-account submodule

# v4.3.0 - 2021-10-08

Added
  * AZ-55: Add ability to manage Update management for Linux and Windows VMs with Automation account
  * AZ-302: Add a default Azure Monitor Data Collection Rule

Changed
  * AZ-572: Revamp examples and improve CI

# v4.2.0 - 2021-09-22

Breaking
  * AZ-546: Clean module, remove unused variables, needs a `terraform state mv` for renamed modules
  * AZ-160: Unify diagnostics settings on all Claranet modules

Changed
  * AZ-516: Add management of weekly, monthly and yearly backup in backup policies
  * AZ-532: Revamp README with latest `terraform-docs` tool

# v4.1.0 - 2021-02-22

Changed
  * AZ-445: Remove datasource to get log_analytics_workspace_id and get it from variable (https://github.com/terraform-providers/terraform-provider-azurerm/pull/10162)
  * AZ-445: Fix deprecation warns on automation-account

Added
  * AZ-448: Added `identity` variable for backup module

Breaking
  * AZ-448/AZ-445: Require AzureRM provider `v2.43+`

# v3.1.1/v4.0.0 - 2020-11-19

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

# v3.1.0 - 2020-11-19

Added
  * AZ-316: Add input for resource specific tags

Changed
  * AZ-320: Add more outputs for automation account

# v3.0.0 - 2020-07-30

Breaking
  * AZ-198: Upgrade AzureRM 2.0

Changed
  * AZ-209: Update CI with Gitlab template

# v2.3.0 - 2020-07-30

Added
  * AZ-216: Enable diagnostics settings

Breaking
  * AZ-216: Change and unify module input variables
  * AZ-216: Automation default name now contains region and environment

# v2.2.0 - 2020-03-30

Added
  * AZ-208: Add automation account module

# v2.1.0 - 2020-01-31

Added
  * AZ-137: File share backup policy

# v2.0.1 - 2020-01-23

Changed
  * AZ-119: Revamp README and publish this module to Terraform registry

Added
  * AZ-119: Add CONTRIBUTING.md doc and `terraform-wrapper` usage with the module

# v2.0.0 - 2019-09-06

Breaking
  * AZ-94: Terraform 0.12 / HCL2 format

Added
  * AZ-118: Add LICENSE, NOTICE & Github badges

# v0.1.0 - 2019-07-01

Added
  * AZ-102: First version with Azure Recovery Vault for VM backups.
