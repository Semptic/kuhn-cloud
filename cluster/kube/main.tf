locals {
  control_plane_nodepools = [
    {
      name        = "control-plane-fsn1",
      server_type = "cax11",
      location    = "fsn1",
      labels      = ["svccontroller.k3s.cattle.io/enablelb=true"],
      taints      = [],
      count       = 3

      # Enable automatic backups via Hetzner (default: false)
      # backups = true
    },
  ]

}
module "kube-hetzner" {
  providers = {
    hcloud = hcloud
  }
  hcloud_token = var.hcloud_token

  # Fix "Waiting for the k3s server to start..." error on creation
  postinstall_exec = ["restorecon -v /usr/local/bin/k3s"]

  # * For local dev, path to the git repo
  # source = "../../kube-hetzner/"
  # If you want to use the latest master branch
  # source = "github.com/kube-hetzner/terraform-hcloud-kube-hetzner"
  # For normal use, this is the path to the terraform registry
  source = "kube-hetzner/kube-hetzner/hcloud"


  # * Your ssh public key
  ssh_public_key = file("~/.ssh/kuhn-cloud_ed25519.pub")
  # * Your private key must be "ssh_private_key = null" when you want to use ssh-agent for a Yubikey-like device authentification or an SSH key-pair with a passphrase.
  # For more details on SSH see https://github.com/kube-hetzner/kube-hetzner/blob/master/docs/ssh.md
  ssh_private_key = file("~/.ssh/kuhn-cloud_ed25519")
  # You can add additional SSH public Keys to grant other team members root access to your cluster nodes.
  # ssh_additional_public_keys = []

  # These can be customized, or left with the default values
  # * For Hetzner locations see https://docs.hetzner.com/general/others/data-centers-and-connection/
  network_region = "eu-central" # change to `us-east` if location is ash

  control_plane_nodepools = local.control_plane_nodepools

  agent_nodepools = [
    {
      name        = "agent-small-arm",
      server_type = "cax11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 0

      # Enable automatic backups via Hetzner (default: false)
      # backups = true
    },
  ]

  # Cluster Autoscaler
  # Providing at least one map for the array enables the cluster autoscaler feature, default is disabled
  # By default we set a compatible version with the default initial_k3s_channel, to set another one,
  # have a look at the tag value in https://github.com/kubernetes/autoscaler/blob/master/charts/cluster-autoscaler/values.yaml
  # ⚠️ Based on how the autoscaler works with this project, you can only choose either x86 instances or ARM server types for ALL autocaler nodepools.
  # Also, as mentioned above, for the time being ARM cax* instances are only available in fsn1.
  # If you are curious, it's ok to have a multi-architecture cluster, as most underlying container images are multi-architecture too.
  # * Example below:
  autoscaler_nodepools = [
    {
      name        = "autoscaled-arm-small"
      server_type = "cax11",
      location    = "fsn1"
      min_nodes   = 0
      max_nodes   = 5
    }
  ]

  # To enable Hetzner Storage Box support, you can enable csi-driver-smb, default is "false".
  enable_csi_driver_smb = true

  # To use local storage on the nodes, you can enable Longhorn, default is "false".
  # See a full recap on how to configure agent nodepools for longhorn here https://github.com/kube-hetzner/terraform-hcloud-kube-hetzner/discussions/373#discussioncomment-3983159
  # Also see Longhorn best practices here https://gist.github.com/ifeulner/d311b2868f6c00e649f33a72166c2e5b
  enable_longhorn = true

  # To disable Hetzner CSI storage, you can set the following to "true", default is "false".
  disable_hetzner_csi = true

  # Use the klipperLB (similar to metalLB), instead of the default Hetzner one, that has an advantage of dropping the cost of the setup.
  # Automatically "true" in the case of single node cluster (as it does not make sense to use the Hetzner LB in that situation).
  # It can work with any ingress controller that you choose to deploy.
  # Please note that because the klipperLB points to all nodes, we automatically allow scheduling on the control plane when it is active.
  enable_klipper_metal_lb = "true"

  # If you want to disable the metric server set this to "false". Default is "true".
  enable_metrics_server = true

  # If you want to allow non-control-plane workloads to run on the control-plane nodes, set this to "true". The default is "false".
  # True by default for single node clusters, and when enable_klipper_metal_lb is true. In those cases, the value below will be ignored.
  allow_scheduling_on_control_plane = true

  # If you want to allow all outbound traffic you can set this to "false". Default is "true".
  restrict_outbound_traffic = false

  # Extra values that will be passed to the `extra-manifests/kustomization.yaml.tpl` if its present.
  extra_kustomize_parameters = {
    inwx_email : var.inwx_email,
    inwx_user : var.inwx_user,
    inwx_pass : var.inwx_pass,
    smb_user : var.smb_user,
    smb_pass : var.smb_pass,
    tailscale_client_id : var.tailscale_client_id,
    tailscale_secret : var.tailscale_secret,
  }

  # See an working example for just a manifest.yaml, a HelmChart and a HelmChartConfig examples/kustomization_user_deploy/README.md

  # It is best practice to turn this off, but for backwards compatibility it is set to "true" by default.
  # See https://github.com/kube-hetzner/terraform-hcloud-kube-hetzner/issues/349
  # When "false". The kubeconfig file can instead be created by executing: "terraform output --raw kubeconfig > cluster_kubeconfig.yaml"
  # Always be careful to not commit this file!
  create_kubeconfig = true

  # Don't create the kustomize backup. This can be helpful for automation.
  create_kustomization = false
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
  type      = string
  sensitive = true
}
variable "tailscale_secret" {
  type      = string
  sensitive = true
}

output "kubeconfig" {
  value     = module.kube-hetzner.kubeconfig
  sensitive = true
}

output "num_control_plane_nodes" {
  value = sum([for pool in local.control_plane_nodepools : pool.count])

}
output "ingress_public_ipv4" {
  value = module.kube-hetzner.ingress_public_ipv4 == module.kube-hetzner.control_planes_public_ipv4[0] ? module.kube-hetzner.control_planes_public_ipv4 : [module.kube-hetzner.ingress_public_ipv4]
}

output "ingress_public_ipv6" {
  value = module.kube-hetzner.ingress_public_ipv6 == null ? [] : [module.kube-hetzner.ingress_public_ipv6]
}
