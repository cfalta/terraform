resource_prefix = "ADCS"
node_location   = "westeurope"
node_count      = 1

node_address_space = ["10.11.0.0/16"]
node_address_prefix = "10.11.0.0/24"

vmsize = "Standard_D2s_v3"

active_directory_domain = "contoso.com"
safemode_password = "P@ssw0rd123!!!"
active_directory_netbios_name = "CONTOSO"

adminuser = "adminuser"
adminpassword = "P@ssw0rd123!!!"

tags = {
  "Environment" = "Test"
}