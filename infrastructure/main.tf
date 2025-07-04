# Configure the Terraform runtime requirements.
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.105.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.3"
    }
  }

}

# Define providers and their config params
provider "azurerm" {
  # Leave the features block empty to accept all defaults
  features {}
}

provider "cloudinit" {
  # Configuration options
}

resource "azurerm_resource_group" "cluster" {
  name     = "kluster-group"
  location = "westus3"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "kubernetes_cluster"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
  dns_prefix          = "leaks1"
  kubernetes_version  = 1.22

  default_node_pool {
    name       = "default"
    node_count = 1
    max_count  = 3
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }

}