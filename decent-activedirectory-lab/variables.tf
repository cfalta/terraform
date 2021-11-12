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

# how many vms to create

variable "node_count" {
  type = number
}

# local admin credentials (also used for linux vm)

variable "locadm_pwd" {
  type = string
}

variable "locadm_user" {
  type = string
}


# Active Directory & Domain Controller

#fqdn of the domain

variable "active_directory_domain" {
  type = string
  description = "The name of the Active Directory domain, for example `consoto.local`"
}

#safemode password

variable "safemode_password" {
  type = string
  description = "The password associated with the local administrator account on the virtual machine"
}

#netbios name of the domain

variable "active_directory_netbios_name" {
  type = string
  description = "The netbios name of the Active Directory domain, for example `consoto`"
}

# domain admin credentials

variable "domadm_pwd" {
  type = string
}

variable "domadm_user" {
  type = string
}
