resource "azurerm_resource_group" "coreservices" {
  name = var.rgname
  location = var.rglocation
}