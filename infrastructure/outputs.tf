output "frontend_app_url" {
  description = "The URL of the frontend web app"
  value       = azurerm_app_service.frontend.default_site_hostname
}

output "backend_app_url" {
  description = "The URL of the backend web app"
  value       = azurerm_app_service.backend.default_site_hostname
}
