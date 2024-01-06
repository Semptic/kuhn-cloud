module "kube" {
  providers = {
    hcloud = hcloud
  }
  source = "./kube"

  hcloud_token = var.hcloud_token
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

output "kubeconfig" {
  value     = module.kube.kubeconfig
  sensitive = true
}

variable "name" {
  type = string
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}