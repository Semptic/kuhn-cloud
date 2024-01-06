module "cluster" {
  providers = {
    hcloud = hcloud
    inwx   = inwx
  }
  source = "./cluster"

  hcloud_token = var.hcloud_token

  inwx_user  = var.inwx_user
  inwx_email = var.inwx_email
  inwx_pass  = var.inwx_pass

  smb_user = var.smb_user
  smb_pass = var.smb_user

  domain = "kuhn.cloud"
  name   = "k8s"
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

provider "inwx" {
  api_url  = "https://api.domrobot.com/jsonrpc/"
  username = var.inwx_user
  password = var.inwx_pass
}

provider "hcloud" {
  token = var.hcloud_token
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

output "kubeconfig" {
  value     = module.cluster.kubeconfig
  sensitive = true
}
