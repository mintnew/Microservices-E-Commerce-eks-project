locals {
  services = [
    "emailservice",
    "checkoutservice",
    "recommendationservice",
    "frontend",
    "paymentservice",
    "productcatalogservice",
    "cartservice",
    "loadgenerator",
    "currencyservice",
    "shippingservice",
    "adservice"
  ]
}

# Create Resource Group for ACR
resource "azurerm_resource_group" "acr_rg" {
  name     = "rg-acr-project"
  location = "eastus"
}

# Create Azure Container Registry
resource "azurerm_container_registry" "services" {
  for_each = toset(local.services)

  name                     = "acr${each.value}"       # Must be globally unique
  resource_group_name      = azurerm_resource_group.acr_rg.name
  location                 = azurerm_resource_group.acr_rg.location
  sku                      = "Standard"               # Basic / Standard / Premium
  admin_enabled            = true                     # Optional: enable admin credentials

  tags = {
    Environment = "production"
    Service     = each.value
  }
}

output "acr_login_server" {
  value = { for s, r in azurerm_container_registry.services : s => r.login_server }
}

output "acr_admin_username" {
  value = { for s, r in azurerm_container_registry.services : s => r.admin_username }
  sensitive = true
}

output "acr_admin_password" {
  value = { for s, r in azurerm_container_registry.services : s => r.admin_password }
  sensitive = true
}