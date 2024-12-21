# Event Hub Namespace
resource "azurerm_eventhub_namespace" "eh_namespace" {
  name                = "ehnamespace-terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
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
  resource_group_name = azurerm_resource_group.rg.name
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
  resource_group_name = azurerm_resource_group.rg.name
  listen              = true
  send                = true
  manage              = true
}



# Output Event Hub Name
output "eventhub_name" {
  value = azurerm_eventhub.event_hub.name
}
