resource "azurerm_user_assigned_identity" "identity" {
  name                = "jumphost-identity"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}