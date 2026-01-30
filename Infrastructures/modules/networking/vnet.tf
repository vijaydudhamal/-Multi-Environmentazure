data "azurerm_resource_group" "rg" {
    name = var.resource_group_name
          
}

resource "azurerm_virtual_network" "vnet" {
    name = "vnet-${var.env_prefix}"
    location = data.azurerm_resource_group.rg
    resource_group_name = data.azurerm_resource_group.rg
    address_space = ["var.vnet_cidr"]

    tags = merge(var.common_tags,{
        environment = var.env_prefix
    })
}

resource "azurerm_subnet" "subnet" {
    name = "sbnet-${"var.env_prefix"}"
    resource_group_name = data.azurerm_resource_group.rg
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["var.subnet_cidr"]
  
}

resource "azurerm_network_interface" "nic" {
    name = "nic-${"var.en_prefix"}"
    resource_group_name = data.azurerm_resource_group.rg
    location = data.azurerm_resource_group.rg

    ip_configuration {
      name = "internal"
      subnet_id = module.network.subnet_id
      private_ip_address_allocation = "Dynamic"
    }
  
}

# Grant AKS permission to access the Key Vault
resource "azurerm_key_vault_access_policy" "aks_to_kv" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  
  # This grabs the Identity created automatically by the AKS cluster
  object_id    = azurerm_kubernetes_cluster.aks.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

