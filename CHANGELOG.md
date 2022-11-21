# Unreleased

Added
  * [GH-2](https://github.com/claranet/terraform-azurerm-run-common/pull/2): Expose `log_analytics_workspace_location`

# v7.1.0 - 2022-11-14

Changed
  * AZ-901: Bump `storage-account` module to `v7.2.0` in `logs` submodule
  * AZ-901: Bump `keyvault` module to `v7.0.1`
  * AZ-901: Bump `function-app` module to `v7.0.1` - fix Storage Account firewall for monitoring function

# v7.0.0 - 2022-09-30

Breaking
  * AZ-840: Upgrade to Terraform 1.3+

# v6.4.0 - 2022-08-12

Breaking
  * AZ-130: Use our `storage-account` module instead of inline resources

Added
  * AZ-815: Added example for logs archive and retention parameters

Changed
  * AZ-808: Use current Tenant ID by default

# v6.3.0 - 2022-07-08

Added
  * AZ-792: Add default tags as extra dimensions in FAME

# v6.2.1 - 2022-06-24

Fixed
  * AZ-776: Fix outputs reference for `function-app` module (monitoring/FAME sub-module)

# v6.2.0 - 2022-06-17

Breaking
  * AZ-717: Bump monitoring module to use latest function-app version for provider v3

Added
  * AZ-578: Add TotalFlowCount metric for VPN Gateways in FAME queries

Changed
  * AZ-686: Update FAME release version for better error management

# v6.1.0 - 2022-06-10

Added
  * AZ-768: Add `monitoring_function_app_service_plan_name`
  * AZ-770: Add Terraform module info in output

Fixed
  * AZ-588: Add parameters to configure FAME storage network rules (required by table queries Terraform resources)

# v6.0.1 - 2022-05-18

Fixed
  * AZ-588: Bump monitoring/function-app module to `v6.0.1`

# v6.0.0 - 2022-05-10

Breaking
  * AZ-717: Minimum Terraform version required `v1.1`
  * AZ-717: Upgrade module to AzureRM provider `v3.0+`

# v5.2.0 - 2022-04-29

Added
  * AZ-672: Add FAME queries for FrontDoor Standard/Premium

# v5.1.2 - 2022-04-21

Fixed
  * AZ-726: Fix version of AzureRM provider due to [bug introduced in v2.99](https://github.com/hashicorp/terraform-provider-azurerm/issues/15821)

# v5.1.1 - 2022-03-29

Changed
  * AZ-717: Prevent using the azurerm v3 provider

# v5.1.0 - 2022-02-17

Added
  * AZ-615: Add an option to enable or disable default tags

Fixed
  * AZ-674: Fix SAS token generation bug (datasource that reference a non created resource). Clean no more needed module variables.

# v5.0.0 - 2022-01-18

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+

# v4.6.0 - 2022-01-18

Changed:
  * AZ-664: Update README with FAME extra dimensions

Added
  * AZ-664: Add FAME queries table name output

Fixed
  * AZ-665: Fix FAME backup queries when logs stored in AzureDiagnostics table
  * AZ-665: Add time range all log queries

# v4.5.0 - 2022-01-12

Breaking
  * AZ-647: Fix `external` provider version constraint (compatible Terraform 0.13+ only)

Changed
  * AZ-572: Revamp examples and improve CI
  * AZ-650: Refactor `log` module and re-use our existing `storage-sas-token` module instead of inline script

Added
  * AZ-569: Allow activating advanced threat protection on FAME function app's storage account

# v4.4.0 - 2021-09-07

Breaking
  * AZ-560: Module Function-App updated to latest `4.1.0`

Added
  * AZ-560: Add FAME custom name inputs

# v4.3.1 - 2021-08-27

Changed
  * AZ-532: Revamp README with latest `terraform-docs` tool

# v4.3.0 - 2021-06-29

Breaking
  * AZ-393: Remove support of Terraform 0.12

Added
  * AZ-393: Monitoring Function for extra Azure metrics

Changed
  * AZ-533: Improve variables documentation
  * AZ-546: Follow Terraform module development recommendations

# v4.2.0 - 2021-06-03

Updated
  * AZ-481: With Terraform 0.14 and 0.15, sensitive attributes should also be set as sensitive outputs
  * AZ-481: Module Azure Keyvault updated to latest `v4.4.0`

Breaking
  * AZ-160: Unify diagnostics settings, update Azure Keyvault module related parameters

# v4.1.0 - 2021-02-26

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
