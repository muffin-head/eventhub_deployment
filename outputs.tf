output "eventhub_namespace_connection_string" {
  value     = azurerm_eventhub_namespace.eh_namespace.default_primary_connection_string
  sensitive = true
}

output "eventhub_name" {
  value = azurerm_eventhub.event_hub.name
}
