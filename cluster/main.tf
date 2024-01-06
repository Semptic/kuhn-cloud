module "kube" {
  providers = {
    hcloud = hcloud
  }
  source = "./kube"

  hcloud_token = var.hcloud_token

  inwx_user = var.inwx_user
  inwx_email = var.inwx_email
  inwx_pass = var.inwx_pass

  smb_user = var.smb_user
  smb_pass = var.smb_user

  tailscale_client_id = var.tailscale_client_id
  tailscale_secret = var.tailscale_secret
}

module "dns" {
  providers = {
    inwx = inwx
  }
  source = "./dns"

  domain = var.domain
  name = var.name

  ingress_public_ipv4 = module.kube.ingress_public_ipv4
  num_ingress_public_ipv4 = module.kube.num_control_plane_nodes
  ingress_public_ipv6 = module.kube.ingress_public_ipv6
  num_ingress_public_ipv6 = 0

  depends_on = [ module.kube ]
}

terraform {
  required_version = ">= 1.4.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.41.0"
    }
    inwx = {
      source  = "inwx/inwx"
      version = ">= 1.0.0"
    }
  }
}

output "kubeconfig" {
  value     = module.kube.kubeconfig
  sensitive = true
}

variable "domain" {
  type = string
}
variable "name" {
  type = string
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "inwx_user" {
  type = string
}
variable "inwx_pass" {
  type      = string
  sensitive = true
}
variable "inwx_email" {
  type = string
}

variable "smb_user" {
  type = string
}
variable "smb_pass" {
  type      = string
  sensitive = true
}

variable "tailscale_client_id" {
  type     = string
  sensitive = true
}
variable "tailscale_secret" {
  type      = string
  sensitive = true
}