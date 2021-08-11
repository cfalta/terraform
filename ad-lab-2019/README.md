# ad-lab-2019

Creates a small Active Directory environment to play with. This will create 3 servers.

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
- All member servers are joined automatically. You can configure the number of servers that are created by changing the "node_count" variable in terraform.tfvars. Default is 2.
- All servers run Server 2019.
- Local Windows firewall will be disabled on ALL vms.
- NSG will allow RDP from ANY IP into the subnet. Make sure to change this.

## Credentials

The credentials for the default domain admin account are:

**Username:** adminuser<br>
**Password:** P@ssw0rd123!!!

The credentials for the default local admin account are:

**Username:** adminuser<br>
**Password:** P@ssw0rd123!


