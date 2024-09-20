## 7.11.0 (2024-09-20)

### Features

* **AZ-1457:** add Customer Managed Key usage 890e2ad

### Miscellaneous Chores

* **deps:** update dependency terraform-docs to v0.19.0 ba63499
* **deps:** update dependency trivy to v0.55.0 7521663
* **deps:** update dependency trivy to v0.55.1 67ed4e2
* **deps:** update dependency trivy to v0.55.2 b77555a
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 88e4538
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 b88484e
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 370c618
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 776fa7c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 05eadc3
* **deps:** update tools 81d53ae

## 7.10.5 (2024-08-31)

### Bug Fixes

* bump `storage-account` to latest version 6549262

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.0 a101f8b
* **deps:** update dependency opentofu to v1.8.1 5ef5b76
* **deps:** update dependency pre-commit to v3.8.0 8f29d68
* **deps:** update dependency tflint to v0.53.0 4dc8e2a
* **deps:** update dependency trivy to v0.54.1 a92d598
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 7dd787f
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 661580c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 aed7377
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 5e0a9a3
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 f243c9e

## 7.10.4 (2024-07-19)


### ⚠ BREAKING CHANGES

* **AZ-1429:** require AzureRM provider `v3.107.0+`

### Code Refactoring

* **AZ-1429:** replace deprecated `retention_duration` with `operational_default_retention_duration` 120a4ba


### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.3 8f7461a
* **deps:** update dependency tflint to v0.51.2 a05a99f
* **deps:** update dependency tflint to v0.52.0 e272565
* **deps:** update dependency trivy to v0.53.0 be53c38
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 ce433aa

## 7.10.3 (2024-06-14)


### ⚠ BREAKING CHANGES

* bump minimum AzureRM provider version

### Code Refactoring

* module storage requires provider `v3.102+` a4da955


### Miscellaneous Chores

* **deps:** update dependency claranet/function-app/azurerm to ~> 7.12.0 23eb913
* **deps:** update dependency claranet/storage-account/azurerm to ~> 7.13.0 105cdf3
* **deps:** update dependency opentofu to v1.7.2 b96e950
* **deps:** update dependency terraform-docs to v0.18.0 ad63f61
* **deps:** update dependency trivy to v0.51.2 1afb589
* **deps:** update dependency trivy to v0.51.4 00180f6
* **deps:** update dependency trivy to v0.52.0 9d5f1bd
* **deps:** update dependency trivy to v0.52.1 6d7e25e
* **deps:** update dependency trivy to v0.52.2 cb8eadc

## 7.10.2 (2024-05-17)


### Documentation

* variable messages tweaks a83bd42


### Miscellaneous Chores

* **deps:** update dependency claranet/storage-account/azurerm to ~> 7.12.0 7822c86
* **deps:** update dependency opentofu to v1.7.0 6efa8e6
* **deps:** update dependency opentofu to v1.7.1 938d55f
* **deps:** update dependency pre-commit to v3.7.1 7daeda6
* **deps:** update dependency tflint to v0.51.0 5c6b89c
* **deps:** update dependency tflint to v0.51.1 4e597a7
* **deps:** update dependency trivy to v0.51.0 0765b22
* **deps:** update dependency trivy to v0.51.1 00cfe73
* **deps:** update terraform claranet/function-app/azurerm to ~> 7.10.0 f4cc6e4
* **deps:** update terraform claranet/function-app/azurerm to ~> 7.11.0 35ccd40

## 7.10.1 (2024-04-26)


### Styles

* **output:** remove unused version from outputs-module ca87dfe


### Miscellaneous Chores

* **release:** remove legacy `VERSION` file 470397a

## 7.10.0 (2024-04-26)


### Features

* **AZ-1400:** fix naming fa371b0
* **AZ-1400:** remove AzAPI resource for update-center submodule and use dedicated azurerm resource b225079


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] a4c8b73
* **AZ-1391:** update semantic-release config [skip ci] e307bcb


### Miscellaneous Chores

* **deps:** enable automerge on renovate 586f73c
* **deps:** update dependency claranet/storage-account/azurerm to ~> 7.11.0 440881e
* **deps:** update dependency trivy to v0.50.2 5e1e471
* **deps:** update dependency trivy to v0.50.4 f7c560a
* **deps:** update terraform claranet/function-app/azurerm to ~> 7.9.0 f07f31e
* **pre-commit:** update commitlint hook 8f3b72a

# v7.9.0 - 2024-03-29

Changed
  * AZ-1362: Migrate App Insights of monitoring function to workspace-based

# v7.8.1 - 2024-02-23

Fixed
  * AZ-1354: Amended cross region RSV variable description to avoid confusion

# v7.8.0 - 2023-12-22

Added
  * AZ-1269: Add FAME query to check IPSEC Tunnels on VPN Gateways

# v7.7.0 - 2023-12-05

Added
 * [GITHUB-2](https://github.com/claranet/terraform-azurerm-run/pull/2): Add `log_analytics_workspace_daily_quota_gb` variable

Fixed
 * [GITHUB-2](https://github.com/claranet/terraform-azurerm-run/pull/2): Lookup with 2 arguments is deprecated (terraform_deprecated_lookup)

# v7.6.3 - 2023-10-20

Changed
  * AZ-1218: Bump function-app module version

# v7.6.2 - 2023-09-29

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
