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
 
### Initial Setup

Before you can deploy the infrastructure, you must create a `terraform.tfvars`
and set the required variables. An example `terraform.tfvars` is provided in 
the `examples` directory

| Variable                | Description                                                        |                                                                                                   
|-------------------------|--------------------------------------------------------------------|
| prefix                  | The prefix is used for domain names                                | 
| ssh_key                 | Path to your public key                                            |
| ssh_key_name            | The name to use for creating the SSH keypair resource in OpenStack |
| openstack_project       | The name of OpenStack project (formerly known as tenant)           |
| infoblox_zone           | FQDN of you InfoBlox subzone                                       |
| infoblox_dns_view       | Infoblox DNS view                                                  |
| infoblox_server         | Infoblox Grid Manager server's IP address or hostname              |
| infoblox_username       | Infoblox username                                                  |
| build_controller_flavor | Compute instance flavor for build controller                       |
| build_controller_image  | Image to use for build controller                                  |
| build_node_count        | Number of build nodes to create                                    |
| build_node_flavor       | Compute instance flavor for build nodes                            |
| build_node_image        | Image to use for build nodes                                       |


### Mac Users on Apple Silicon

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

