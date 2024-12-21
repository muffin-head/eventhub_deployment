# Configure the Azure Provider
provider "azurerm" {
  features {}
  use_cli = true  # Use Azure CLI for authentication
}

# Event Hub Namespace
resource "azurerm_eventhub_namespace" "eh_namespace" {
  name                = "ehnamespace-terraform"
  location            = "East US"  # Use the same location as the AKS and ACR deployment
  resource_group_name = "rg-aks-acr-terraform"  # Existing resource group name
  sku                 = "Standard"
  capacity            = 1


}

# Event Hub
resource "azurerm_eventhub" "event_hub" {
  name           = "eventhub-terraform"
  namespace_id   = azurerm_eventhub_namespace.eh_namespace.id  # Use namespace_id instead of resource_group_name
  partition_count = 2
  message_retention = 1


}

# Shared Access Policy
resource "azurerm_eventhub_namespace_authorization_rule" "eh_auth_rule" {
  name                = "RootManageSharedAccessKey"
  namespace_name      = azurerm_eventhub_namespace.eh_namespace.name
  resource_group_name = "rg-aks-acr-terraform"  # Existing resource group name
  listen              = true
  send                = true
  manage              = true
}

