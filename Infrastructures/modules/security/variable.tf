variable "common_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Project = "CloudMigration"
    ManagedBy = "Terraform"
  }
}

variable "env_prefix" {
    description = "The environment name (dev, qa, or prod)"
    type = string
  
}