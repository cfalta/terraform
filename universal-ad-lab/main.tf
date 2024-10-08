##########################################################
# Create base infrastructure
##########################################################

# resource group
resource "azurerm_resource_group" "lab_rg" {
  name     = "${var.resource_prefix}-RG"
  location = var.node_location
  tags = var.tags
}

# virtual network within the resource group
resource "azurerm_virtual_network" "windows_vnet" {
  name                = "${var.resource_prefix}-vnet"
  resource_group_name = azurerm_resource_group.lab_rg.name
  location            = var.node_location
  address_space       = var.node_address_space
  dns_servers         = [cidrhost(var.node_address_prefix, 10)]
  tags = var.tags
}

# subnet within the virtual network
resource "azurerm_subnet" "windows_subnet" {
  name                 = "${var.resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.windows_vnet.name
  address_prefixes       = [var.node_address_prefix]

}

##########################################################
# Create vm components
##########################################################

# public ips - member clients
resource "azurerm_public_ip" "windows_client_public_ip" {
  count = var.node_count_windows_client
  name  = "${var.resource_prefix}-WC-${format("%02d", count.index)}-PublicIP"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.resource_prefix}-wc-${format("%02d", count.index)}"

  tags = var.tags
}

# network interfaces - member clients
resource "azurerm_network_interface" "windows_client_nic" {
  count = var.node_count_windows_client
  name = "${var.resource_prefix}-WC-${format("%02d", count.index)}-NIC"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  tags = var.tags

  ip_configuration {
    name      = "internal"
    subnet_id = azurerm_subnet.windows_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.node_address_prefix, 50+count.index)
    public_ip_address_id          = element(azurerm_public_ip.windows_client_public_ip.*.id, count.index)
  }
}

# public ips - member server
resource "azurerm_public_ip" "windows_server_public_ip" {
  count = var.node_count_windows_server
  name  = "${var.resource_prefix}-WS-${format("%02d", count.index)}-PublicIP"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.resource_prefix}-ws-${format("%02d", count.index)}"

  tags = var.tags
}

# network interfaces - member server
resource "azurerm_network_interface" "windows_server_nic" {
  count = var.node_count_windows_server
  name = "${var.resource_prefix}-WS-${format("%02d", count.index)}-NIC"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  tags = var.tags

  ip_configuration {
    name      = "internal"
    subnet_id = azurerm_subnet.windows_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.node_address_prefix, 100+count.index)
    public_ip_address_id          = element(azurerm_public_ip.windows_server_public_ip.*.id, count.index)
  }
}

# public ips - linux server
resource "azurerm_public_ip" "linux_server_public_ip" {
  count = var.node_count_linux_server
  name  = "${var.resource_prefix}-NIX-${format("%02d", count.index)}-PublicIP"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.resource_prefix}-nix-${format("%02d", count.index)}"

  tags = var.tags
}

# network interfaces - linux server
resource "azurerm_network_interface" "linux_server_nic" {
  count = var.node_count_linux_server
  name = "${var.resource_prefix}-NIX-${format("%02d", count.index)}-NIC"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  tags = var.tags

  ip_configuration {
    name      = "internal"
    subnet_id = azurerm_subnet.windows_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.node_address_prefix, 150+count.index)
    public_ip_address_id          = element(azurerm_public_ip.linux_server_public_ip.*.id, count.index)
  }
}

# public ip - dc
resource "azurerm_public_ip" "dc_public_ip" {
  name = "${var.resource_prefix}-DC-PublicIP"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.resource_prefix}-dc"
  tags = var.tags
}

# network interface - dc
resource "azurerm_network_interface" "dc_nic" {
  name = "${var.resource_prefix}-DC-NIC"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  tags = var.tags

  ip_configuration {
    name      = "internal"
    subnet_id = azurerm_subnet.windows_subnet.id
    #private_ip_address_allocation = "Dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.node_address_prefix, 10)
    public_ip_address_id          = azurerm_public_ip.dc_public_ip.id
  }
}

# public ip - ca
resource "azurerm_public_ip" "ca_public_ip" {
  name = "${var.resource_prefix}-CA-PublicIP"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.resource_prefix}-ca"
  tags = var.tags
}

# network interface - ca
resource "azurerm_network_interface" "ca_nic" {
  name = "${var.resource_prefix}-CA-NIC"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  tags = var.tags

  ip_configuration {
    name      = "internal"
    subnet_id = azurerm_subnet.windows_subnet.id
    #private_ip_address_allocation = "Dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.node_address_prefix, 11)
    public_ip_address_id          = azurerm_public_ip.ca_public_ip.id
  }
}

# public ip - tailscale gateway
resource "azurerm_public_ip" "gateway_public_ip" {
  name = "${var.resource_prefix}-GATEWAY-PublicIP"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  allocation_method   = "Dynamic"
  domain_name_label = "${var.resource_prefix}-gateway"
  tags = var.tags
}

# network interface - tailscale gateway
resource "azurerm_network_interface" "gateway_nic" {
  name = "${var.resource_prefix}-GATEWAY-NIC"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  tags = var.tags

  ip_configuration {
    name      = "internal"
    subnet_id = azurerm_subnet.windows_subnet.id
    #private_ip_address_allocation = "Dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.node_address_prefix, 20)
    public_ip_address_id          = azurerm_public_ip.gateway_public_ip.id
  }
}

# NSG
resource "azurerm_network_security_group" "lab_nsg" {

  name                = "${var.resource_prefix}-NSG"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name

  # Security rule can also be defined with resource azurerm_network_security_rule, here just defining it inline as a template.
  # Since we're using tailscale to connect to the lab, we don't need public access
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
  #  security_rule {
  #  name                       = "RDPInbound"
  #  priority                   = 101
  #  direction                  = "Inbound"
  #  access                     = "Allow"
  #  protocol                   = "Tcp"
  #  source_port_range          = "*"
  #  destination_port_range     = "3389"
  #  source_address_prefix      = "*"
  #  destination_address_prefix = "*"
  #}

  tags = var.tags
}

# Subnet and NSG association
resource "azurerm_subnet_network_security_group_association" "windows_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.windows_subnet.id
  network_security_group_id = azurerm_network_security_group.lab_nsg.id

}

##########################################################
# Sleep - we need this to give the DC enough time to provision before joining VMs
##########################################################

resource "time_sleep" "wait_300_seconds" {
  create_duration = "300s"
 depends_on = [azurerm_virtual_machine_extension.create-active-directory-forest]
}


##########################################################
# Create VMs
##########################################################

# VM object for member clients - will create X server based on the respective node_count variable in terraform.tfvars
resource "azurerm_windows_virtual_machine" "windows_client_vm" {
  count = var.node_count_windows_client
  name  = "${var.resource_prefix}-WC-${format("%02d", count.index)}"
  location              = azurerm_resource_group.lab_rg.location
  resource_group_name   = azurerm_resource_group.lab_rg.name
  network_interface_ids = [element(azurerm_network_interface.windows_client_nic.*.id, count.index)]
  size                  = var.vmsize
  admin_username        = var.locadm_user
  admin_password        = var.locadm_pwd

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-10"
    sku       = "win10-22h2-ent"
    version   = "latest"
  }

  depends_on = [time_sleep.wait_300_seconds]

  tags = var.tags
}

# VM object for member server - will create X server based on the respective node_count variable in terraform.tfvars
resource "azurerm_windows_virtual_machine" "windows_server_vm" {
  count = var.node_count_windows_server
  name  = "${var.resource_prefix}-WS-${format("%02d", count.index)}"
  location              = azurerm_resource_group.lab_rg.location
  resource_group_name   = azurerm_resource_group.lab_rg.name
  network_interface_ids = [element(azurerm_network_interface.windows_server_nic.*.id, count.index)]
  size                  = var.vmsize
  admin_username        = var.locadm_user
  admin_password        = var.locadm_pwd

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  depends_on = [time_sleep.wait_300_seconds]

  tags = var.tags
}

# VM object for linux server - will create X server based on the respective node_count variable in terraform.tfvars
resource "azurerm_linux_virtual_machine" "linux_server_vm" {
  count = var.node_count_linux_server
  name  = "${var.resource_prefix}-NIX-${format("%02d", count.index)}"
  location              = azurerm_resource_group.lab_rg.location
  resource_group_name   = azurerm_resource_group.lab_rg.name
  network_interface_ids = [element(azurerm_network_interface.linux_server_nic.*.id, count.index)]
  size                  = var.vmsize
  admin_username        = var.locadm_user
  admin_password        = var.locadm_pwd
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

  depends_on = [time_sleep.wait_300_seconds]

  tags = var.tags
}

#VM object for the DC - contrary to the member server, this one is Static so there will be only a single DC
resource "azurerm_windows_virtual_machine" "windows_vm_domaincontroller" {
  name  = "${var.resource_prefix}-DC"
  location              = azurerm_resource_group.lab_rg.location
  resource_group_name   = azurerm_resource_group.lab_rg.name
  network_interface_ids = [azurerm_network_interface.dc_nic.id]
  size                  = var.vmsize
  admin_username        = var.domadm_user
  admin_password        = var.domadm_pwd

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  tags = var.tags
}

#VM object for the ca
resource "azurerm_windows_virtual_machine" "windows_vm_ca" {
  name  = "${var.resource_prefix}-CA"
  location              = azurerm_resource_group.lab_rg.location
  resource_group_name   = azurerm_resource_group.lab_rg.name
  network_interface_ids = [azurerm_network_interface.ca_nic.id]
  size                  = var.vmsize
  admin_username        = var.locadm_user
  admin_password        = var.locadm_pwd

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  depends_on = [time_sleep.wait_300_seconds]

  tags = var.tags
}

#VM object for an ubuntu gateway VM for tailscale
resource "azurerm_linux_virtual_machine" "gateway_vm" {
  name  = "${var.resource_prefix}-GATEWAY"
  location              = azurerm_resource_group.lab_rg.location
  resource_group_name   = azurerm_resource_group.lab_rg.name
  network_interface_ids = [azurerm_network_interface.gateway_nic.id]
  size                  = var.vmsize
  admin_username        = var.locadm_user
  admin_password        = var.locadm_pwd
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

  depends_on = [time_sleep.wait_300_seconds]

  tags = var.tags
}

##########################################################
## Define VM extensions to install ADDS and join member
##########################################################

# Set powershell scripts to run
# based on https://github.com/ghostinthewires/terraform-azurerm-promote-dc

locals { 
  import_command       = "Import-Module ADDSDeployment"
  password_command     = "$password = ConvertTo-SecureString ${var.safemode_password} -AsPlainText -Force"
  install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
  configure_ad_command = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode Win2012R2 -DomainName ${var.active_directory_domain} -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode Win2012R2 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
  shutdown_command     = "shutdown -r -t 10"
  powershell_command   = "${local.disable_fw}; ${local.import_command}; ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"
  
	exit_code_hack       = "exit 0"

  disable_fw          = "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False"
  powershell_command_disable_fw   = "${local.disable_fw}; ${local.exit_code_hack}"

  deploy_adcs = "Add-WindowsFeature adcs-cert-authority,RSAT-ADCS,RSAT-ADCS-mgmt,RSAT-ADDS"

	powershell_command_deploy_adcs = "${local.disable_fw}; ${local.deploy_adcs}; ${local.exit_code_hack}"
}

# Create AD forest/domain

resource "azurerm_virtual_machine_extension" "create-active-directory-forest" {
  name                 = "create-active-directory-forest"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_vm_domaincontroller.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
SETTINGS
}

# Join Client VM to Active Directory Domain
# based on https://github.com/ghostinthewires/terraform-azurerm-ad-join

resource "azurerm_virtual_machine_extension" "join-domain_windows_client" {
  count = var.node_count_windows_client
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_client_vm[count.index].id
  name                 = "join-domain_windows_client"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  

#NOTE: the oupath field is intentionally blank, to put it in the Computers OU

  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "",
        "User": "${var.active_directory_domain}\\${var.domadm_user}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.domadm_pwd}"
    }
SETTINGS
}

# windows clients extension to disable the Windows firewall

resource "azurerm_virtual_machine_extension" "disable_fw_member_client" {
  depends_on = [azurerm_virtual_machine_extension.join-domain_windows_client]
  count = var.node_count_windows_client
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_client_vm[count.index].id
  name                 = "disable_fw"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command_disable_fw}\""
    }
SETTINGS
}

# Join Server VM to Active Directory Domain
# based on https://github.com/ghostinthewires/terraform-azurerm-ad-join

resource "azurerm_virtual_machine_extension" "join-domain_windows_server" {
  count = var.node_count_windows_server
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_server_vm[count.index].id
  name                 = "join-domain_windows_server"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  

#NOTE: the oupath field is intentionally blank, to put it in the Computers OU

  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "",
        "User": "${var.active_directory_domain}\\${var.domadm_user}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.domadm_pwd}"
    }
SETTINGS
}

# windows server extension to disable the Windows firewall

resource "azurerm_virtual_machine_extension" "disable_fw_member_server" {
  depends_on = [azurerm_virtual_machine_extension.join-domain_windows_server]
  count = var.node_count_windows_server
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_server_vm[count.index].id
  name                 = "disable_fw"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command_disable_fw}\""
    }
SETTINGS
}

# join CA vm to domain prior to ADCS deployment

resource "azurerm_virtual_machine_extension" "join-domain-ca" {

  virtual_machine_id   = azurerm_windows_virtual_machine.windows_vm_ca.id
  name                 = "join-domain"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  

#NOTE: the oupath field is intentionally blank, to put it in the Computers OU

  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "",
        "User": "${var.active_directory_domain}\\${var.domadm_user}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.domadm_pwd}"
    }
SETTINGS
}

# deploy adcs on CA vm
# note - configuration needs to be done manually afterwards like this:
# Install-AdcsCertificationAuthority -CAType EnterpriseRootCa -ValidityPeriod Years -ValidityPeriodUnits 10 -Force

resource "azurerm_virtual_machine_extension" "deploy_adcs_ca" {
  depends_on = [azurerm_virtual_machine_extension.join-domain-ca]
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_vm_ca.id
  name                 = "deploy-adcs-ca"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command_deploy_adcs}\""
    }
SETTINGS
}

#Deploy tailscale border router
resource "azurerm_virtual_machine_extension" "deploy_tailscale" {
  depends_on = [azurerm_linux_virtual_machine.gateway_vm]
  virtual_machine_id   = azurerm_linux_virtual_machine.gateway_vm.id
  name                 = "deploy-tailscale"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
 type_handler_version   = "2.1"

  settings = <<SETTINGS
    {
        "commandToExecute": "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -; curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list; sudo apt-get update; sudo apt-get install tailscale -y; sudo sysctl -w net.ipv4.ip_forward=1; echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf; sudo tailscale up --authkey ${var.tailscale_authkey} --advertise-routes=${var.node_address_prefix}"
    }
SETTINGS
}