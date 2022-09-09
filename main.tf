# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-terraform-setup" {
  name     = "terraform-setup-ResourceGroup"
  location = "westus2"
}

resource "azurerm_virtual_network" "vn-terraform-setup" {
  name                = "terraform-setup-vnetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-terraform-setup.location
  resource_group_name = azurerm_resource_group.rg-terraform-setup.name
}

resource "azurerm_subnet" "sn-terraform-setup" {
  name                 = "terraform-setup-snet"
  resource_group_name  = azurerm_resource_group.rg-terraform-setup.name
  virtual_network_name = azurerm_virtual_network.vn-terraform-setup.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_storage_account" "sta-terraform-setup" {
  name                     = "terraformsetupsta"
  resource_group_name      = azurerm_resource_group.rg-terraform-setup.name
  location                 = azurerm_resource_group.rg-terraform-setup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.sn-terraform-setup.id]
  }

  tags = {
    environment = "staging"
  }
}