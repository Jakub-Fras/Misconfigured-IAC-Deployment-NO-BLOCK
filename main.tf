terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-misconfig-demo-no-block"
  location = "West Europe"
}

resource "azurerm_storage_account" "public_sa" {
  name                     = "publicblob"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # In v3.x this supersedes the old allow_blob_public_access
  allow_nested_items_to_be_public = true

  # (Optional) allow the storage account to be reached over the public network
  public_network_access_enabled = true

  network_rules {
    default_action = "Allow"
  }
}