# Unreleased

Added
  * AZ-1038: Add parameters to Key Vault module
  * AZ-1070: Add `vm_backup_policy_type` new parameter

Breaking
  * AZ-1038: Bump Key Vault module. Use `var.keyvault_custom_name` to keep your Key Vault when upgrading

Fixed
  * AZ-1070: Fix VM backup policy configuration when `vm_backup_policy_frequency` is set to `Weekly`

# v7.2.2 - 2023-04-07

Fixed
  * AZ-1051: Fix logs retention variables for Key Vault and monitoring function modules

# v7.2.1 - 2023-03-31

Fixed
  * AZ-1037: Bump function-app module for monitoring function

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
