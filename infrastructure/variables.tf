variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "West Europe"
}

variable "sku_tier" {
  description = "The SKU tier of the Azure App Service Plan."
  type        = string
  validation {
    condition     = contains(["Free", "Basic", "Standard", "Premium"], var.sku_tier)
    error_message = "The SKU tier must be one of Free, Basic, Standard, or Premium."
  }
}

variable "sku_size" {
  description = "The SKU size of the Azure App Service Plan."
  type        = string
  validation {
    condition     = contains(["F1", "B1", "B2", "S1", "S2", "P1", "P2"], var.sku_size)
    error_message = "The SKU size must be one of F1, B1, B2, S1, S2, P1, or P2."
  }
}
