module "network" {
    source = "../../modules/networking"
    env_prefix = var.env_prefix
    resource_group_name = var.resource_group_name
    vnet_cidr = var.vnet_cidr
    subnet_cidr = var.subnet_cidr
    #aks_node_count = var.aks_node_count
    common_tags = var.common_tags

}

module "Aks" {
    source = "../../modules/aks"
    env_prefix = var.env_prefix
    resource_group_name = var.resource_group_name
    aks_node_count = var.aks_node_count
    common_tags = var.common_tags
  
}

module "security" {
    source = "../../modules/security"
    env_prefix = var.env_prefix
 
}

module "kv" {
    source = "../../modules/keyvault"
    env_prefix = var.env_prefix
    resource_group_name = var.resource_group_name
      
}

