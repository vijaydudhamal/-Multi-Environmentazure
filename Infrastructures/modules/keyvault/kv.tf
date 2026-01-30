data "azurerm_resource_group" "rg" {
    name = var.resource_group_name
 
}

resource "azurerm_key_vault" "kv" {
    name = "kv-${var.env_prefix}-${unique_id}"
    resource_group_name = data.azurerm_resource_group_name
    location = data.azurerm_resource_group_location
    enabled_for_disk_encryption = true
    tenant_id = data.azurerm_client_config_current.tenant_id
    soft_delete_retention_days = 7
    purge_protection_enabled = false

    sku_name = "standard"

    network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    # Only allow traffic from the subnet we created earlier
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
  }

    access_policy {
        tenant_id = data.azurerm_client_config_current.tenant_id
        object_id = data.azurerm_client_config_current.object_id

        secret_permissions = [
            "Get", "List", "Set", "Delete", "Purge", "Recover"
        ]
    }

    tags = merge(var.common_tags, {
    environment = var.env_prefix
  })    
  
}