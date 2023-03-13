# softpack-iac / openstack

## Overview

This directory contains configuration files for deploying SoftPack 
infrastructure on [OpenStack](https://www.openstack.org) platform.

[Terraform](https://www.terraform.io) and [Ansible](https://www.ansible.com) 
are used for deployment, provisioning, and teardown of the infrastructure and
[Infoblox Terraform Provider](https://github.com/infobloxopen/terraform-provider-infoblox)
for DNS configuration.

### Requirements

- Terraform >= 1.3.2
- Ansible >= 2.14.2

#### Mac Users on Apple Silicon

If you're using a Mac on Apple Silicon (M1 or M2), then you'd have to build an
older version of Infoblox Terraform Provider yourself.

Infoblox `2.2.0` reports an error when creating an A-record. The workaround is to
use version [2.1.0](https://github.com/infobloxopen/terraform-provider-infoblox/releases/tag/v2.1.0).

On most platforms, terraform will automatically download the correct version
of all providers for you based on the contents of `terraform-providers.tf`.
However, version `2.1.0` for Apple Silicon does not exist, so it requires
cloning the repo, checking out version `2.1.0`, building the provider, and
copying it to:

`~/.terraform.d/plugins/terraform.local/local/infoblox/2.1.0/darwin_arm64/terraform-provider-infoblox_v2.1.0`


### Initial Setup

In order to deploy and provision the infrastructure, you'll have to create 
configurations for terraform and ansible.

#### Terraform 

Create a `terraform.tfvars` file and set the required variables. An example 
`terraform.tfvars` is provided in the `examples` directory.

| Variable                | Description                                                        |                                                                                                   
|-------------------------|--------------------------------------------------------------------|
| prefix                  | The prefix is used for domain names                                | 
| ssh_key                 | Path to your public key                                            |
| ssh_key_name            | The name to use for creating the SSH keypair resource in OpenStack |
| openstack_project       | The name of OpenStack project (formerly known as tenant)           |
| infoblox_zone           | FQDN of your InfoBlox subzone                                      |
| infoblox_dns_view       | Infoblox DNS view                                                  |
| infoblox_server         | Infoblox Grid Manager server's IP address or hostname              |
| infoblox_username       | Infoblox username                                                  |
| build_controller_flavor | Compute instance flavor for build controller                       |
| build_controller_image  | Image to use for build controller                                  |
| build_node_count        | Number of build nodes to create                                    |
| build_node_flavor       | Compute instance flavor for build nodes                            |
| build_node_image        | Image to use for build nodes                                       |


Once you've created a `terraform.tfvars` file, verify that all the 
configuration options are correct using the following command:

``` console
terraform plan
```

If the configuration looks correct, you can proceed and create the 
infrastructure resources.

``` console
terraform apply
```

After the infrastructure is created, you might have to wait for a short amount
of time for the DNS cache to be flushed before you can provision the resources. 
You can also reset the DNS cache manually by turning off and turning back on 
your network interface momentarily.

#### Ansible

Create `ansible/vars/vars.yml` file to override the following default variables 
in `ansible/vars/defaults.yml`.

| Variable       | Description                                                                     |                                                                                                   
|----------------|---------------------------------------------------------------------------------|
| domain         | The domain name for your network                                                | 
| dns_zone       | The DNS zone for your network                                                   | 
| ssl_cert       | Name of your SSL certificate. Make sure to place the file under `etc/ssl/certs` | 
| artifacts_repo | The URL of your artifacts repo                                                  | 
| ldap_uri       | The URI of the LDAP server (must include ldap:// or ldaps:// scheme)            | 
| ldap_base_dn   | The Base DN of your LDAP server                                                 | 
| ldap_filter    | LDAP filter to restrict access to the build controller or build nodes           | 

To provision with `ansbile`, make sure you're in the `ansible` directory and
run the playbook.

```console
ansible-playbook main.yml
```

### Development

The instructions in this section are intended for development and testing 
purposes only and may not apply to your specific configuration.

For convenience, you can add the following to your `~/.ssh/config` file.

``` console
Host softpack-*
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  Hostname %h.aa27.sanger.ac.uk
```

You can also add your SSH public key to the build controller or build nodes.

``` console
ssh-copy-id softpack-build-controller
```

In order to take advantage of Prefect monitoring server, you must copy config
from `/opt/config/user` to your home directory.

```
cp -r /opt/config/user/. ~
```

You also need to enable Spack shell integration if you're planning to manually
create Spack environments for development or testing. You can enable shell
integration for Spack using one of the following commands.

**Bash**

```console
cat << EOF >> ~/.bashrc

# enable spack shell support
source /opt/spack/share/spack/setup-env.sh

EOF
```

**Zsh**

```console
cat << EOF >> ~/.zshrc

# enable spack shell support
source /opt/spack/share/spack/setup-env.sh

EOF
```
