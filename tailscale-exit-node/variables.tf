# azure location

variable "node_location" {
  type = string
}

# prefix for your lab, this will be prepended to all resources

variable "resource_prefix" {
  type = string
}

# vnet address space

variable "node_address_space" {
  default = ["10.10.0.0/16"]
}

# subnet range

variable "node_address_prefix" {
  default = "10.10.10.0/24"
}

# tags to apply to all resources

variable "tags" {
  description = "Tags to apply on resource"
  type        = map(string)
}

# default vmsize

variable "vmsize" {
  type = string
}

# local admin user

variable "locadm_user" {
  type = string
}

# tailscale auth key

variable "tailscale_authkey" {
  type = string
}

# virtual machine name

variable "node_vmname" {
  type = string
}