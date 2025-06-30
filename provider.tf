terraform {
required_providers {
azurerm={
source="hashicorp/azurerm"
version=">= 3.0.0"
    }
  }
}

provider"azurerm" {
    subscription_id = "f7b7810e-d86f-4a01-b3f5-98306ae64b51"
features {}
}