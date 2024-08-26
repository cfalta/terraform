# universal-ad-lab

Creates a lab to play with attacks on Active Directory and/or Active Directory Certificate Services. This will create the following VMs by default:

 - 1 DC (Server 2022)
 - 1 Member Server for ADCS (Server 2022)
 - X Member Clients (Windows 10 22H2), use `node_count_windows_client` variable to set the number of VMs to create
 - X Member Server (Windows Server 2022), use `node_count_windows_server` variable to set the number of VMs to create
 - X Ubuntu Server (Ubuntu 22.04 LTS), use `node_count_linux_server` variable to set the number of VMs to create
 - 1 Tailscale Subnet Router (Ubuntu 22.04 LTS), advertises the lab network via tailscale

**Warning:** this will create a lab environment, which intenionally contains unsafe defaults like disabling firewalls or using insecure passwords. Do NOT use in production.

## Contents

- main.tf
  - the main terraform config file (don't edit unless you know what u are doing)
- providers.tf
  - set the terraform provider (don't edit unless you know what u are doing)
- variables.tf
  - definition of all variables used in main.tf (you don't want to edit this too)
- terraform.tfvars
  - That's the file you want to edit :-). Use this file to set the variables defined in variables.tf like the number of members to create, the IP ranges or the default passwords.

## Defaults

Check terraform.tfvars for the configurable settings. Besides that, the main.tf will also enforce the following:

- Every VM is prefixed with the label you set in terraform.tfvars (ressource_prefix).
- The Active Directory domain is installed with defaults automatically. A single DC is created and always has the name "LABEL"-DC.
- A member server destined to become the CA will be deployed under the name "LABEL"-CA. ADCS is installed but not configured. You can run the following command to deploy a 10y Enterprise Root CA
  - `Install-AdcsCertificationAuthority -CAType EnterpriseRootCa -ValidityPeriod Years -ValidityPeriodUnits 10 -Force`
- All member servers and clients are joined automatically. You can configure the number of clients and server that are created by changing the respective "node_count" variable in terraform.tfvars. Default is one each.
- All Windows servers run Server 2022, all Clients run Windows 10 22H2.
- Local Windows firewall will be disabled on ALL VMs.
- NSG will allow RDP/SSH from ANY IP into the subnet. Make sure to change this.

## Credentials

The credentials for the default local admin account (also used on Linux) are:

**Username:** locadm<br>
**Password:** P@ssw0rd123???

The credentials for the default domain admin account are:

**Username:** domadm<br>
**Password:** P@ssw0rd123!!!