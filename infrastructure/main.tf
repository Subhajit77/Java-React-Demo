provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "webappdemo" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "acrJavaReactApp"
  resource_group_name = azurerm_resource_group.webappdemo.name
  location            = azurerm_resource_group.webappdemo.location
  sku                 = "Basic"
}

# App Service Plan
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "appServicePlan"
  location            = azurerm_resource_group.webappdemo.location
  resource_group_name = azurerm_resource_group.webappdemo.name

  sku {
    tier = var.sku_tier
    size = var.sku_size
  }
}

# Frontend Web App
resource "azurerm_app_service" "frontend" {
  name                = "frontendApp"
  location            = azurerm_resource_group.webappdemo.location
  resource_group_name = azurerm_resource_group.webappdemo.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
}

# Backend Web App
resource "azurerm_app_service" "backend" {
  name                = "backendApp"
  location            = azurerm_resource_group.webappdemo.location
  resource_group_name = azurerm_resource_group.webappdemo.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
}

# Autoscale setting for Frontend
resource "azurerm_monitor_autoscale_setting" "frontend_autoscale" {
  name                = "autoscaleSetting"
  location            =  azurerm_resource_group.webappdemo.location
  resource_group_name =  azurerm_resource_group.webappdemo.name
  target_resource_id  =  azurerm_app_service.frontend.id

  profile {
    name = "scale-up"

    capacity {
      minimum = 1
      maximum = 5
      default = 2
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_app_service_plan.asp.id
        operator           = "GreaterThan"
        time_aggregation   = "Average"
        threshold          = 80
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }
    }
  }
}

# Autoscale setting for Backend
resource "azurerm_monitor_autoscale_setting" "backend_autoscale" {
  name                = "autoscaleSetting"
  location            =  azurerm_resource_group.webappdemo.location
  resource_group_name =  azurerm_resource_group.webappdemo.name
  target_resource_id  =  azurerm_app_service.backend.id

  profile {
    name = "scale-up"

    capacity {
      minimum = 1
      maximum = 5
      default = 2
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_app_service_plan.asp.id
        operator           = "GreaterThan"
        time_aggregation   = "Average"
        threshold          = 80
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT1M"
      }
    }
  }
}
