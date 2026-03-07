
locals {
  ports = ["22","80","443","8080","9000","9090","3306"]
}

resource "azurerm_resource_group" "rg" {
  name     = "jumphost-rg"
  location = "Canada Central"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "jumphost-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "Canada Central"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "public1" {
  name                 = "public-subnet1"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "public2" {
  name                 = "public-subnet2"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "private1" {
  name                 = "private-subnet1"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "private2" {
  name                 = "private-subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "jumphost-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

}

resource "azurerm_network_security_rule" "rukes" {
  for_each = toset(["22", "80", "443", "8080", "9000", "9090", "3306"])

  name                        = "port-${each.value}"
  priority                    = 100 + index(local.ports, each.value)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "vm_ip" {
  name                = "jumphost-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_network_interface" "nic" {
  name                = "jumphost-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }
}
