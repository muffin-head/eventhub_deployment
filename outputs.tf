output "eventhub_namespace_connection_string" {
  value = azurerm_eventhub_namespace_authorization_rule.eh_auth_rule.primary_connection_string
}

output "eventhub_name" {
  value = azurerm_eventhub.event_hub.name
}
