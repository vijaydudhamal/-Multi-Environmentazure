env_prefix          = "prod"
resource_group_name = "rg-existing-dev-ae"
vnet_cidr           = "10.20.0.0/16"
subnet_cidr         = "10.20.1.0/24"
aks_node_count      = 2
common_tags = {
  Environment = "Production"
  Owner       = "Prod-Team"
}