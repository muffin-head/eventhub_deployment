# Event Hub Namespace
resource "azurerm_eventhub_namespace" "eh_namespace" {
  name                = "ehnamespace-terraform"
  location            = "East US"  # Use the same location as the AKS and ACR deployment
  resource_group_name = "rg-aks-acr-terraform"  # Replace with the existing resource group name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = "dev"
  }
}

# Event Hub
resource "azurerm_eventhub" "event_hub" {
  name                = "eventhub-terraform"
  namespace_name      = azurerm_eventhub_namespace.eh_namespace.name
  resource_group_name = "rg-aks-acr-terraform"  # Replace with the existing resource group name
  partition_count     = 2
  message_retention   = 1

  tags = {
    environment = "dev"
  }
}

# Shared Access Policy
resource "azurerm_eventhub_namespace_authorization_rule" "eh_auth_rule" {
  name                = "RootManageSharedAccessKey"
  namespace_name      = azurerm_eventhub_namespace.eh_namespace.name
  resource_group_name = "rg-aks-acr-terraform"  # Replace with the existing resource group name
  listen              = true
  send                = true
  manage              = true
}

