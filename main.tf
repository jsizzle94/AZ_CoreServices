resource "azurerm_resource_group" "coreservices" {
  name = "${var.application}-RG"
  location = var.rglocation
}
resource "azurerm_virtual_network" "hubnetwork" {
    name = "${var.application}-VNet"
    address_space = ["10.100.0.0/16"]
    location = azurerm_resource_group.coreservices.location
    resource_group_name = azurerm_resource_group.coreservices.name
}
resource "azurerm_subnet" "subnets" {
  count = length(var.subnets)
  address_prefixes = [var.subnets[count.index]]
  name = "${var.application}-Sub1"
  virtual_network_name = azurerm_virtual_network.hubnetwork.name
  resource_group_name = azurerm_resource_group.coreservices.name
}