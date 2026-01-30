# 1. Correct Data Source: Use one block to get all RG attributes
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# 2. Corrected AKS Resource
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.env_prefix}"
  location            = data.azurerm_resource_group.rg.location # Reference the data block attribute
  resource_group_name = data.azurerm_resource_group.rg.name     # Reference the data block attribute
  dns_prefix          = "aks-${var.env_prefix}"                 # Added missing closing quote

  default_node_pool {
    name           = "default"
    node_count     = var.aks_node_count # Used variable for scaling
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"    # Was "plugin", corrected to "network_plugin"
    load_balancer_sku = "standard" # Was "load_balance_sku", corrected to "load_balancer_sku"
  }

  tags = merge(var.common_tags, {
    Environment = var.env_prefix
  })
}