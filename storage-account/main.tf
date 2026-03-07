terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "tfstate-rg"
  location = "East US"
}

# Storage Account 1
resource "azurerm_storage_account" "storage1" {
  name                     = "aluruarumullaa1"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Environment = "dev"
  }
}

# Storage Account 2
resource "azurerm_storage_account" "storage2" {
  name                     = "arumullaaluruu1"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Environment = "dev"
  }
}

# Container 1
resource "azurerm_storage_container" "container1" {
  name                 = "container1"
  storage_account_id   = azurerm_storage_account.storage1.id
  container_access_type = "private"
}

# Container 2
resource "azurerm_storage_container" "container2" {
  name                 = "container2"
  storage_account_id   = azurerm_storage_account.storage2.id
  container_access_type = "private"
}