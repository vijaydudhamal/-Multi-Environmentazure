terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  # This prevents Terraform from attempting to register Azure Resource Providers
  # (like Microsoft.Compute or Microsoft.Network) at the subscription level.
  resource_provider_registrations = "none" 
}