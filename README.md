# kuhn-cloud-k8s

This uses [Kube-Hetzner](https://github.com/kube-hetzner/terraform-hcloud-kube-hetzner) to setup the k8s cluster on hetzner cloud.

To get started you need to copy `secrets.auto.tfvars.example` to `secrets.auto.tfvars` and fill the secrets.

# kubectl

Get the config with `terraform output --raw kubeconfig > kubeconfig.yaml` and use it like `kubectl --kubeconfig kubeconfig.yaml ...`.