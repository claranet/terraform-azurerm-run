# Design: FAME OBC/Prometheus Integration in monitoring-function module

**Date:** 2026-03-17
**Branch:** feat_az-1643_add_fame_obc_run
**FAME Reference:** https://git.fr.clara.net/claranet/projects/cloud/azure/serverless/fame/-/tree/feat/obc
**FAME Version:** 2.2.0-beta-0.1

## Context

The FAME (Function App for Metrics Extraction) `feat/obc` branch adds support for a third metrics backend: **ObsByClara/Prometheus Remote Write**. This backend sends Azure metrics to a Prometheus-compatible endpoint (such as AWS Managed Prometheus) using the Prometheus Remote Write protocol with AWS SigV4 authentication.

The existing module supports two backends:
- **Splunk Observability** (`SFX_TOKEN` env var)
- **Datadog** (`DD_API_KEY` env var)

This design adds ObsByClara as a third option.

## Goal

Update the `monitoring-function` module (both inner module and root-level wrappers) to support ObsByClara/Prometheus as a metrics backend, while maintaining backward compatibility with existing Splunk and Datadog configurations.

## FAME OBC Technical Summary

The OBC backend requires the following environment variables in the Azure Function App:

| Variable | Required | Default | Description |
|---|---|---|---|
| `OBC_ENDPOINT` | Yes (if OBC) | — | Prometheus Remote Write endpoint URL |
| `OBC_REGION` | Yes (if OBC) | — | AWS region for SigV4 signing |
| `OBC_SERVICE` | Yes (if OBC) | `aps` | AWS service name (usually `aps` for AWS Managed Prometheus) |
| `AWS_ACCESS_KEY_ID` | Yes (if OBC) | — | AWS access key ID |
| `AWS_SECRET_ACCESS_KEY` | Yes (if OBC) | — | AWS secret access key |
| `AWS_SESSION_TOKEN` | No | — | AWS session token (temporary credentials) |
| `OBC_MAX_RETRIES` | No | `3` | Maximum retry attempts |

**Backend priority** in FAME: ObsByClara > Datadog > SignalFx (Splunk)

## Decisions

| Question | Decision | Rationale |
|---|---|---|
| FAME version | `2.2.0-beta-0.1` | Current OBC beta on feat/obc branch |
| Variable structure | Individual variables | Consistent with existing splunk_token/datadog_api_key pattern |
| Validation | Exactly 1 backend + OBC cross-validation | Strict validation, early error detection at `plan` |
| Sensitive marking | On AWS credentials only (not endpoint) | `obc_endpoint` is a URL, not a secret; marking it sensitive would redact all `app_settings` in plan output |

## Files to Modify

| File | Change type |
|---|---|
| `modules/monitoring-function/variables.tf` | Add 7 OBC variables |
| `modules/monitoring-function/locals.tf` | Update `app_settings` |
| `modules/monitoring-function/README.md` | Document new variables (via terraform-docs) |
| `variables-monitoring-function.tf` (root) | Add 7 OBC variables + update zip_package_path default |
| `m-monitoring-function.tf` (root) | Update preconditions + module call |
| `README.md` (root) | Document new variables (via terraform-docs) |

### 1. `modules/monitoring-function/variables.tf`

Add 7 new variables for OBC configuration:

```hcl
variable "obc_endpoint" {
  description = "ObsByClara/Prometheus Remote Write endpoint URL."
  type        = string
  default     = null
}

variable "obc_region" {
  description = "AWS region for SigV4 signing when using ObsByClara backend."
  type        = string
  default     = null
}

variable "obc_service" {
  description = "AWS service name for SigV4 signing. Typically `aps` for AWS Managed Prometheus."
  type        = string
  default     = "aps"
}

variable "obc_aws_access_key_id" {
  description = "AWS access key ID for ObsByClara authentication."
  type        = string
  default     = null
  sensitive   = true
}

variable "obc_aws_secret_access_key" {
  description = "AWS secret access key for ObsByClara authentication."
  type        = string
  default     = null
  sensitive   = true
}

variable "obc_aws_session_token" {
  description = "AWS session token for ObsByClara authentication with temporary credentials."
  type        = string
  default     = null
  sensitive   = true
}

variable "obc_max_retries" {
  description = "Maximum retry attempts for ObsByClara failed requests."
  type        = number
  default     = null
}
```

### 2. `modules/monitoring-function/locals.tf`

Update `app_settings` to include OBC environment variables:

```hcl
app_settings = merge(
  {
    LOG_ANALYTICS_WORKSPACE_GUID = var.log_analytics_workspace_guid,
    SUBSCRIPTION_ID              = data.azurerm_client_config.current.subscription_id,
    METRICS_EXTRA_DIMENSIONS     = local.extra_dimensions,
  },
  var.extra_application_settings,
  var.splunk_token != null ? { SFX_TOKEN = var.splunk_token } : {},
  var.datadog_api_key != null ? { DD_API_KEY = var.datadog_api_key } : {},
  var.obc_endpoint != null ? { OBC_ENDPOINT = var.obc_endpoint } : {},
  var.obc_region != null ? { OBC_REGION = var.obc_region } : {},
  var.obc_endpoint != null ? { OBC_SERVICE = var.obc_service } : {},
  var.obc_aws_access_key_id != null ? { AWS_ACCESS_KEY_ID = var.obc_aws_access_key_id } : {},
  var.obc_aws_secret_access_key != null ? { AWS_SECRET_ACCESS_KEY = var.obc_aws_secret_access_key } : {},
  var.obc_aws_session_token != null ? { AWS_SESSION_TOKEN = var.obc_aws_session_token } : {},
  var.obc_max_retries != null ? { OBC_MAX_RETRIES = tostring(var.obc_max_retries) } : {},
)
```

**Notes:**
- Each variable is guarded individually by a null check, consistent with the existing pattern for `AWS_SESSION_TOKEN` and `OBC_MAX_RETRIES`. This avoids injecting `null` values into `app_settings` if credentials are omitted.
- `OBC_SERVICE` uses `obc_endpoint != null` as its gate (rather than `obc_service != null`) because `obc_service` has a non-null default `"aps"` and would otherwise always be injected. **Important:** `obc_service` must never be added to the `compact()` list in the precondition for this same reason — it would always be truthy and break the backend count logic.
- The inner module (`modules/monitoring-function/`) intentionally has no self-defense precondition. It is always consumed via the root-level wrapper (`m-monitoring-function.tf`) which owns the validation. This is acceptable for an embedded module not published independently.

### 3. `variables-monitoring-function.tf` (root)

Mirror the 7 OBC variables with `monitoring_function_` prefix, plus update `zip_package_path` default:

- 7 new `monitoring_function_obc_*` variables (same types/defaults/sensitive as inner module)
- `monitoring_function_zip_package_path` default → `https://github.com/claranet/fame/releases/download/v2.2.0-beta-0.1/fame.zip`

### 4. `m-monitoring-function.tf` (root)

**Update existing precondition** (exactly 1 backend):
```hcl
precondition {
  condition = length(compact([
    var.monitoring_function_splunk_token,
    var.monitoring_function_datadog_api_key,
    var.monitoring_function_obc_endpoint,
  ])) == 1
  error_message = "Exactly one of `var.monitoring_function_datadog_api_key`, `var.monitoring_function_splunk_token`, or `var.monitoring_function_obc_endpoint` must be set when `var.monitoring_function_enabled` is set to `true`."
}
```

**Add new cross-validation precondition** (OBC required fields):
```hcl
precondition {
  condition = var.monitoring_function_obc_endpoint == null || (
    var.monitoring_function_obc_region != null &&
    var.monitoring_function_obc_aws_access_key_id != null &&
    var.monitoring_function_obc_aws_secret_access_key != null
  )
  error_message = "When `var.monitoring_function_obc_endpoint` is set, `obc_region`, `obc_aws_access_key_id`, and `obc_aws_secret_access_key` must also be set."
}
```

**Add 7 new variable pass-throughs** in the `module "monitoring_function"` block:
```hcl
obc_endpoint              = var.monitoring_function_obc_endpoint
obc_region                = var.monitoring_function_obc_region
obc_service               = var.monitoring_function_obc_service
obc_aws_access_key_id     = var.monitoring_function_obc_aws_access_key_id
obc_aws_secret_access_key = var.monitoring_function_obc_aws_secret_access_key
obc_aws_session_token     = var.monitoring_function_obc_aws_session_token
obc_max_retries           = var.monitoring_function_obc_max_retries
```

## Retrocompatibility

- All new variables default to `null` (or existing defaults like `"aps"` for `obc_service`)
- Existing Splunk and Datadog users are unaffected
- No resources are renamed; no `moved` blocks required
- The precondition change is backward compatible (existing users with exactly one of splunk/datadog set still pass)

## Out of Scope

- CHANGELOG update (separate MR)
- Examples update (separate MR)
- No outputs to add (OBC doesn't create new Azure resources)
