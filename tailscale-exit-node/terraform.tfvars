resource_prefix = "tailscale"
node_location   = "westeurope"

node_address_space = ["10.116.0.0/16"]
node_address_prefix = "10.116.4.0/24"

node_vmname = "az-edge"
vmsize = "Standard_B1s"

locadm_user = "locadm"

tags = {
  "Environment" = "dev"
}