
variable "resource_group_name" {
   type = string
}
variable "aks_node_count" {
   #type = string
  
}

variable "env_prefix" {
   type = string
  
}

variable "subnet_cidr" {
  # type = number
  
}

variable "vnet_cidr" {
  # type = string
  
}

variable "" {
  
}

variable "common_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Project = "CloudMigration"
    ManagedBy = "Terraform"
  }
}