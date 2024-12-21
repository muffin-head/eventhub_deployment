# Configure the Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "1fad5e2e-cd4b-437b-8fff-ee503b4e0e29"
}
# Event Hub Namespace
resource "azurerm_eventhub_namespace" "eh_namespace" {
  name                = "sepsisStreamingEventhubNameSpace"
  location            = "eastus"
  resource_group_name = "rg-datalake-terraform"
  sku                 = "Standard"
  capacity            = 1


}

# Event Hub with Capture to ADLS
resource "azurerm_eventhub" "event_hub" {
  name           = "eventhubsepsisstreaming"
  namespace_id   = azurerm_eventhub_namespace.eh_namespace.id
  partition_count = 1
  message_retention = 1

  capture_description {
    enabled                 = true
    encoding                = "Avro"
    interval_in_seconds     = 300
    size_limit_in_bytes     = 314572800
    destination {
      name       = "EventHubArchive.AzureBlockBlob"
      storage_account_id = "/subscriptions/1fad5e2e-cd4b-437b-8fff-ee503b4e0e29/resourceGroups/rg-datalake-terraform/providers/Microsoft.Storage/storageAccounts/datalaketfexample"
      blob_container_name = "eventhub"  # Target ADLS container for Event Hub captures
      archive_name_format = "eventhub/{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
    }
  }


}

# Shared Access Policy
resource "azurerm_eventhub_namespace_authorization_rule" "eh_auth_rule" {
  name                = "RootManageSharedAccessKey"
  namespace_name      = azurerm_eventhub_namespace.eh_namespace.name
  resource_group_name = "rg-datalake-terraform"
  listen              = true
  send                = true
  manage              = true
}


