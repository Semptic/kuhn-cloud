module "cluster" {
  providers = {
    hcloud = hcloud
  }
  source = "./cluster"

  hcloud_token = var.hcloud_token

  name = "k8s"
}

terraform {
  required_version = ">= 1.4.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.41.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}

output "kubeconfig" {
  value     = module.cluster.kubeconfig
  sensitive = true
}
