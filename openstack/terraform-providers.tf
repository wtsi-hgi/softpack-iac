terraform {
  required_version = ">= 1.3.2"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.3.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
    infoblox = {
      source  = "terraform.local/local/infoblox"
      version = "2.1.0"
    }
  }
}

variable "openstack_project" { type = string }

provider "openstack" {
  cloud = var.openstack_project
}

variable "infoblox_server" { type = string }
variable "infoblox_username" { type = string }

provider "infoblox" {
  server   = var.infoblox_server
  username = var.infoblox_username
}
