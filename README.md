# terraform
A collection of terraform script to create different labs in Azure.

**Warning:** this will create a lab environment, which intenionally contains unsafe defaults like disabling firewalls or using insecure passwords. Do NOT use in production.

That said, here's the list:

- **universal-ad-lab:** sets up a universal lab including a DC, a CA, a configurable number of member server, member clients and linux server. Also sets up a tailscale subnet router so you can access the whole lab via tailscale.
- **tailscale-exit-node:** takes a tailscale auth key as input and creates an Ubuntu server that works as tailscale edge node. Also enables tailscale ssh auth.
- **adcs-lab-2019:** sets up 2 Windows server 2019 and a Windows 10 client. A DC, a CA and a member client.
- **ad-lab-2019:** sets up 3 Windows server 2019. A DC, and two additional member server.
- **ad-lab-2019-with-vm-domainlabel:** same as above, just registers the VM name also as a DNS label for the VM. So you can always RDP to the same DNS name instead of using an IP.

## Usage

The easiest way to use terraform in Azure is through azure cloud shell, since it already includes terraform and you don't have to create an extra security principal for terraform to interact with your tenant. This is a good thing, espescially since we are talking about directory security here - a secure service account is the one we never create ;-)

So open cloudshell from the azure portal and clone the repository.

```
git clone https://github.com/cfalta/terraform
cd ./terraform/<whatever lab you choose>
```

Make sure you are okay with the defaults (Azure location, VM size, admin user and password...)

```
code ./terraform.tfvars
```

And when you're ready: initialize terraform and apply - thats it :-)

```
terraform init
terraform validate
terraform plan
terraform apply
```

Note:

- init = initialize terraform (azure provider)
- validate = make sure there are no syntax errors in the config
- plan = shows you what will happen if you run apply
- apply = create the resources

If you are done playing, just run the following to remove all resources.

```
terraform destroy
```

## Credentials

Find the default credentials in the readme of the lab.