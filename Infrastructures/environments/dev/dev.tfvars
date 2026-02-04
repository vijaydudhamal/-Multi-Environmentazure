env_prefix          = "dev"
resource_group_name = "kml_rg_main-164cd9c20d0a4932"
vnet_cidr           = "10.0.0.0/16"
subnet_cidr         = "10.0.1.0/24"
aks_node_count      = 2
common_tags = {
  Environment = "Development"
  Owner       = "Team-Alpha"
}
