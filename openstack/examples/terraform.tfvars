prefix       = "softpack"
ssh_key      = "~/.ssh/id_rsa.pub"
ssh_key_name = "openstack-key"

openstack_project = "softpack"

infoblox_zone     = "softpack.example.com"
infoblox_dns_view = "default"
infoblox_server   = "infoblox.example.com"
infoblox_username = "softpack"

build_controller_flavor = "m1.tiny"
build_controller_image  = "focal-server"

build_node_count  = 1
build_node_flavor = "m1.tiny"
build_node_image  = "focal-server"
