resource_prefix = "adlab"
node_location   = "westeurope"
node_count_linux_server = 1
node_count_windows_client = 1
node_count_windows_server = 1

node_address_space = ["10.20.0.0/16"]
node_address_prefix = "10.20.20.0/24"

vmsize = "Standard_D2s_v3"

active_directory_domain = "contoso.com"
safemode_password = "P@ssw0rd123!!!"
active_directory_netbios_name = "CONTOSO"

locadm_user = "locadm"
locadm_pwd = "P@ssw0rd123???"

domadm_user = "domadm"
domadm_pwd = "P@ssw0rd123!!!"

tags = {
  "Environment" = "lab"
}