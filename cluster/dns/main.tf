resource "inwx_nameserver_record" "ipv4_record" {
  # module.kube-hetzner.ingress_public_ipv4 == module.kube-hetzner.control_planes_public_ipv4[0] is true if we are not using the hetzner loadbalancer
  count   = var.num_ingress_public_ipv4
  # count = module.kube-hetzner.ingress_public_ipv4 == module.kube-hetzner.control_planes_public_ipv4[0] ? length(module.kube-hetzner.control_planes_public_ipv4) : 1
  domain  = var.domain
  name    = "*.${var.name}.${var.domain}"
  type    = "A"
  # content = module.kube-hetzner.ingress_public_ipv4 == module.kube-hetzner.control_planes_public_ipv4[0] ? module.kube-hetzner.control_planes_public_ipv4[count.index] : module.kube-hetzner.ingress_public_ipv4
  content = var.ingress_public_ipv4[count.index]
}

resource "inwx_nameserver_record" "ipv6_record" {
  count   = var.num_ingress_public_ipv6
  domain  = var.domain
  name    = "*.${var.name}.${var.domain}"
  type    = "AAAA"
  content = var.ingress_public_ipv6[count.index]
}

terraform {
  required_version = ">= 1.4.0"
  required_providers {
    inwx = {
      source  = "inwx/inwx"
      version = ">= 1.0.0"
    }
  }
}

variable "domain" {
  type = string
}
variable "name" {
  type = string
}
variable "num_ingress_public_ipv4" {
  type = number
  default = 0 
}
variable "ingress_public_ipv4" {
  type = list(string)
  default = [] 
}
variable "num_ingress_public_ipv6" {
  type = number
  default = 0 
}
variable "ingress_public_ipv6" {
  type = list(string)
  default = []
}