provider "azurerm" {
  features {}
}

# Configure Azure credentials
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.1"
    }
  }
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name = "petclinic-rg"
  location = "your-location"
}

# Create an AKS cluster
resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "petclinic-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  #node_pool_id        = azurerm_kubernetes_node_pool.pool.id

  default_node_pool {
    name      = "default"
    node_count = 2
    vm_size   = "Standard_B1s"
  }
}

# Create an AKS node pool
# resource "azurerm_kubernetes_node_pool" "pool" {
#   name                = "default-pool"
#   cluster_id           = azurerm_kubernetes_cluster.cluster.id
#   node_count          = 2
#   vm_size             = "Standard_B1s"
#   kubernetes_version  = azurerm_kubernetes_cluster.cluster.kubernetes_version
# }

# Get the cluster credentials
output "cluster_credentials" {
  value = base64decode(azurerm_kubernetes_cluster.cluster.kube_config)
}

# Replace "your-location" with your desired Azure region.
