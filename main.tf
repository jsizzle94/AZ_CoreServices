resource "azurerm_resource_group" "coreservices" {
  name     = "${var.application}-RG"
  location = var.rglocation
}
resource "azurerm_virtual_network" "hubnetwork" {
  name                = "${var.application}-VNet"
  address_space       = ["10.100.0.0/16"]
  location            = azurerm_resource_group.coreservices.location
  resource_group_name = azurerm_resource_group.coreservices.name
}
resource "azurerm_subnet" "subnets" {
  count                = length(var.subnets)
  address_prefixes     = [var.subnets[count.index]]
  name                 = "${var.application}-Sub1"
  virtual_network_name = azurerm_virtual_network.hubnetwork.name
  resource_group_name  = azurerm_resource_group.coreservices.name
}
resource "azurerm_subnet" "gwsubnet" {
  address_prefixes     = var.gwsubnet
  virtual_network_name = azurerm_virtual_network.hubnetwork.name
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.coreservices.name
}
resource "azurerm_public_ip" "vgwpubip" {
  name                = "${var.application}-VGWIP"
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  resource_group_name = azurerm_resource_group.coreservices.name
  location            = azurerm_resource_group.coreservices.location
}

resource "azurerm_network_interface" "vmnic" {
  name                = "${var.application}-vmnic"
  location            = azurerm_resource_group.coreservices.location
  resource_group_name = azurerm_resource_group.coreservices.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnets[0].id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_virtual_machine" "name" {
  name                = "${var.application}-VM"
  vm_size             = "Stanrdars"
  location            = azurerm_resource_group.coreservices.location
  resource_group_name = azurerm_resource_group.coreservices.name
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  network_interface_ids = [azurerm_network_interface.vmnic.id]

}




# resource "azurerm_virtual_network_gateway" "vgw" {
# name                = "${var.application}-VGW"
# location            = azurerm_resource_group.coreservices.location
# resource_group_name = azurerm_resource_group.coreservices.name

# type     = "Vpn"
# vpn_type = "RouteBased"
# sku      = "VpnGw1"

# ip_configuration {
#   name                          = "vgw-ipconf"
#   public_ip_address_id          = azurerm_public_ip.vgwpubip.id
#   subnet_id                     = azurerm_subnet.gwsubnet
#   private_ip_address_allocation = "Dynamic"
# }
# enable_bgp = true
# }