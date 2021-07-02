output "patch_mgmt_linux_template_deployment_id" {
  description = "ID of the template deployment for Linux Patch Management"
  value       = azurerm_template_deployment.update_config_standard_patch_linux[0].id
}

output "patch_mgmt_windows_template_deployment_id" {
  description = "ID of the template deployment for Windows Patch Management"
  value       = azurerm_template_deployment.update_config_standard_patch_windows[0].id
}
