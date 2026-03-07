
terraform {
  required_version = ">=1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.100"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "arumullaaluruu1"
    container_name       = "container2"
    key                  = "k8s/terraform.tfstate"
  }
}

provider "azurerm" {
  features {

  }
}


