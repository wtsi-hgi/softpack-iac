resource "local_file" "ansible_inventory" {
  filename = "ansible/inventory/hosts.yml"
  content = templatefile("ansible/inventory/hosts.tftpl", {
    prefix                    = var.prefix
    private_key               = trimsuffix(var.ssh_key, ".pub")
    build_controller_hostname = local.build_controller_hostname
    build_node_hostnames      = local.build_node_hostnames
  })
}

resource "local_file" "infoblox_list" {
  filename = "infoblox/test/list.json"
  content = templatefile("infoblox/test/list.tftpl", {
    build_nodes               = local.build_nodes
    build_controller_hostname = local.build_controller_hostname
    build_node_hostnames      = values(local.build_node_hostnames)
  })
}
