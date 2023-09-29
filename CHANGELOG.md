# Unreleased

Fixed
  * AZ-1191: Fix tags truncation in `automation-account` submodule

# v7.6.1 - 2023-09-22

Breaking
  * AZ-1153: Remove `retention_days` parameters, it must be handled at destination level now. (for reference: [Provider issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/23051))

Added
  * AZ-1111: Add `windows_kb_ids_to_exclude` and `linux_package_names_to_exclude` parameters for the `update_center_maintenance_configurations` variable
  * AZ-1154: Add `purgeLog` rule to the archive policy in replacement of the `retention_days` parameter deletion.

Changed
  * AZ-1156: Cleanup documentation

Removed
  * AZ-1163: Remove FrontDoor Fame queries

Fixed
  * AZ-1151: Bump fame version to v1.2.1 for monitoring function

Changed
  * AZ-1131: Add deployed resources visualizer in README

# v7.5.0 - 2023-07-21

Added
  * AZ-1114: Add `access_tier` option to `logs` submodule

Fixed
  * AZ-1116: Add missing quotes in migration instructions

# v7.4.1 - 2023-07-07

Fixed
  * AZ-1112: Add missing Update Center tags

Changed
  * AZ-1113: Update sub-modules READMEs (according to their example)

# v7.4.0 - 2023-06-16

Added
  * AZ-1093: Add `logs_storage_account_enabled` option to `logs` submodule
  * AZ-673: Patch Management Monitoring with Fame

# v7.3.2 - 2023-06-02

Changed
  * AZ-1038: Bump `Keyvault` module to remove deprecation warning with AzureRM v4 provider

# v7.3.1 - 2023-05-12

Fixed
  * AZ-1078: Fix Fame backup queries

# v7.3.0 - 2023-04-28

Added
  * AZ-1038: Add parameters to Key Vault module
  * AZ-1070: Add `vm_backup_policy_type` new parameter
  * AZ-1055: Add `client_name` in Storage Account name. Use `var.logs_storage_account_custom_name` to keep your storage when upgrading.
  * AZ-1056: Bump `function-app` module for monitoring function

Breaking
  * AZ-1038: Bump Key Vault module. Use `var.keyvault_custom_name` to keep your Key Vault when upgrading

Fixed
  * AZ-1070: Fix VM backup policy configuration when `vm_backup_policy_frequency` is set to `Weekly`

# v7.2.2 - 2023-04-07

Fixed
  * AZ-1051: Fix logs retention variables for Key Vault and monitoring function modules

# v7.2.1 - 2023-03-31

Fixed
  * AZ-1037: Bump `function-app` module for monitoring function

# v7.2.0 - 2023-03-03

Fixed
  * AZ-1021: variables types for backup inputs

Fixed
  * AZ-926: README typos

Changed
  * AZ-1014: Bump logs `storage-account` and monitoring function modules versions
  * AZ-1020: Fix outputs in `backup` submodule

# v7.1.2 - 2023-02-10

Fixed
  * AZ-998: Fix `samplingFrequencyInSeconds` value (`30` to `60`) in `vm-monitoring` submodule

# v7.1.1 - 2023-01-27

Fixed
  * AZ-926: Fix VM monitoring module creation condition

# v7.1.0 - 2023-01-27

Breaking
  * AZ-926: Cleaning and refactoring

Added
  * AZ-926: Add Backup Vault resources

Removed
  * AZ-926: Remove Log Storage SAS token exposition
  * AZ-926: Remove legacy IIS log ingestion configuration

# v7.0.0 - 2023-01-13

Added
  * AZ-926: Unify and merge `run-common` and `run-iaas` in a unique module
