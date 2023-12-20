
##########################################################
# Configure the Azure Provider
##########################################################
provider "azurerm" {
  features {}
}

##########################################################
# Create base infrastructure
##########################################################

# resource group
resource "azurerm_resource_group" "server_rg" {
  name     = "${var.resource_prefix}-RG"
  location = var.node_location
  tags = var.tags
}

# virtual network within the resource group
resource "azurerm_virtual_network" "server_vnet" {
  name                = "${var.resource_prefix}-vnet"
  resource_group_name = azurerm_resource_group.server_rg.name
  location            = var.node_location
  address_space       = var.node_address_space
  tags = var.tags
}

# subnet within the virtual network
resource "azurerm_subnet" "server_subnet" {
  name                 = "${var.resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.server_rg.name
  virtual_network_name = azurerm_virtual_network.server_vnet.name
  address_prefixes       = [var.node_address_prefix]

}

##########################################################
# Create vm components
##########################################################

# public ip
resource "azurerm_public_ip" "server_public_ip" {
  name = "${var.resource_prefix}-SERVER-PublicIP"
  location            = azurerm_resource_group.server_rg.location
  resource_group_name = azurerm_resource_group.server_rg.name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.resource_prefix}-server"
  tags = var.tags
}

# network interface
resource "azurerm_network_interface" "server_nic" {
  name = "${var.resource_prefix}-SERVER-NIC"
  location            = azurerm_resource_group.server_rg.location
  resource_group_name = azurerm_resource_group.server_rg.name
  tags = var.tags

  ip_configuration {
    name      = "internal"
    subnet_id = azurerm_subnet.server_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.server_public_ip.id
  }
}

# NSG
resource "azurerm_network_security_group" "lab_nsg" {

  name                = "${var.resource_prefix}-NSG"
  location            = azurerm_resource_group.server_rg.location
  resource_group_name = azurerm_resource_group.server_rg.name

  # Security rule can also be defined with resource azurerm_network_security_rule, here just defining it inline.
  #security_rule {
  #  name                       = "SSHInbound"
  #  priority                   = 100
  #  direction                  = "Inbound"
  #  access                     = "Allow"
  #  protocol                   = "Tcp"
  #  source_port_range          = "*"
  #  destination_port_range     = "22"
  #  source_address_prefix      = "*"
  #  destination_address_prefix = "*"
  #}
  tags = var.tags

}

# Subnet and NSG association
resource "azurerm_subnet_network_security_group_association" "server_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.server_subnet.id
  network_security_group_id = azurerm_network_security_group.lab_nsg.id

}

##########################################################
# Create VMs
##########################################################

#Generate local admin password
resource "random_password" "locadm_pwd" {
  length           = 64
  special          = true
  override_special = "_-.@!?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
}


#VM object for an ubuntu VM
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name  = var.node_vmname
  location              = azurerm_resource_group.server_rg.location
  resource_group_name   = azurerm_resource_group.server_rg.name
  network_interface_ids = [azurerm_network_interface.server_nic.id]
  size                  = var.vmsize
  admin_username        = var.locadm_user
  admin_password        = random_password.locadm_pwd.result
  disable_password_authentication = "false"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags
}


resource "azurerm_virtual_machine_extension" "deploy_tailscale" {
  depends_on = [azurerm_linux_virtual_machine.linux_vm]
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vm.id
  name                 = "deploy-tailscale"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
 type_handler_version   = "2.1"

  settings = <<SETTINGS
    {
        "commandToExecute": "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -; curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list; sudo apt-get update; sudo apt-get install tailscale -y; sudo sysctl -w net.ipv4.ip_forward=1; sudo tailscale up --authkey ${var.tailscale_authkey} --advertise-exit-node --ssh"
    }
SETTINGS
}