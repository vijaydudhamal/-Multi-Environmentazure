output "dev_aks_cluster_name" {
  description = "The name of the AKS cluster in Dev"
  value       = module.infrastructure.aks_cluster_name
}

output "dev_key_vault_uri" {
  value = module.infrastructure.key_vault_uri
}