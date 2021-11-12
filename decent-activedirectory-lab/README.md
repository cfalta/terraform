# decent-activedirectory-lab

Creates a lab to play with attacks on Active Directory and/or Active Directory Certificate Services. This will create the following 5 VMs by default:

 - 1 DC (Server 2019)
 - 1 Member Server for ADCS (Server 2019)
 - 2 Member Clients (Windows 10 20H2)
 - 1 Ubuntu Server 18.04

**Warning:** this will create a lab environment, which intenionally contains unsafe defaults like disabling firewalls or using insecure passwords. Do NOT use in production.

## Contents

- main.tf
  - the main terraform config file (don't edit unless you know what u are doing)
- variables.tf
  - definition of all variables used in main.tf (you don't want to edit this too)
- terraform.tfvars
  - use this file to set the variables defined in variables.tf. That's the file you want to edit :-)

## Defaults

Check terraform.tfvars for the configurable settings. Besides that, the main.tf will also enforce the following:

- Every VM is prefixed with the label you set in terraform.tfvars (ressource_prefix).
- The Active Directory domain is installed with defaults automatically. A single DC is created and always has the name "LABEL"-DC.
- A member server destined to become the CA will be deployed under the name "LABEL"-CA. ADCS is NOT installed automatically.
- All member servers and clients are joined automatically. You can configure the number of Windows 10 clients that are created by changing the "node_count" variable in terraform.tfvars. Default is 2.
- All Windows servers run Server 2019, all Clients run Windows 10 20H2.
- Local Windows firewall will be disabled on ALL VMs.
- NSG will allow RDP/SSH from ANY IP into the subnet. Make sure to change this.

## Credentials

The credentials for the default local admin account are:

**Username:** locadm<br>
**Password:** P@ssw0rd123???

The credentials for the default domain admin account are:

**Username:** domadm<br>
**Password:** P@ssw0rd123!!!