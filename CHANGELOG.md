# Unreleased

Added
  * AZ-410: Added a variable to enable choosing a TLS version for the logs storage account (Defaulted to TLS1_2)

Updated
  * AZ-325: Upgrade keyvault module to latest version + Update CI

Fixed
  * AZ-326: Add missing keyvault's inputs

# v3.1.2/v4.0.0 - 2020-12-11

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

# v3.1.1 - 2020-08-06

Fixed
  * AZ-249: Remove main.tf file from logs submodule

# v3.1.0 - 2020-07-31

Added
  * AZ-233: Add lifecycle management on storage account

# v3.0.0 - 2020-07-22
  
Breaking
  * AZ-198: Upgrade module to be compliant with AzureRM 2.0

# v2.2.1 - 2020-07-03

Fixed
  * AZ-162: Cleanup README

# v2.2.0 - 2020-03-25

Changed
  * AZ-199: Fix account should be account in outputs
  * AZ-199: Add possibility to not create the App Service logs container

Added
  * AZ-162: IIS logs gathering option
  * AZ-199: Add possibility to create a fileshare to archive logs

Fixed
  * AZ-206: Pin version of provider AzureRM to be usable under v2.x

# v2.1.0 - 2020-01-24

Changed
  * AZ-117: Revamp sub-module directory to match HashiCorp registry best practices
  * AZ-117: Use KeyVault module from registry at version `v2.0.1`

Added
  * AZ-169: Storage Account - allow to configure account\_kind (default to StorageV2) and enable\_https\_traffic\_only (default to false)

# v2.0.3 - 2019-12-17

Added
  * AZ-128: Output The Log Analytics Workspace name
  * AZ-159: Add storage `enable_advanced_threat_protection` attribute option

Fixed
  * AZ-145: Remove deprecated `resource_group_name` attribute on storage

# v2.0.2 - 2019-11-14

Fixed
  * AZ-134: Resolve issue with storage account name

# v2.0.1 - 2019-10-07

Changed
  * AZ-119: Revamp README for public release

Added
  * AZ-119: Add CONTRIBUTING.md doc and `terraform-wrapper` usage with the module

# v2.0.0 - 2019-09-06

Breaking
  * AZ-94: Terraform 0.12 / HCL2 format

Added
  * AZ-118: Add LICENSE, NOTICE & Github badges

# v1.1.0 - 2019-06-18

Fixed
  * AZ-48: Fix `logs_storage_account_appservices_container_name` variable and README

# v1.0.1 - 2019-05-02

Fixed
  * AZ-48: Fix Key Vault module version

# v1.0.0 - 2019-04-29

Added
  * AZ-48: First version with Key Vault and Log Analytics
