# kuhn-cloud

This uses [Kube-Hetzner](https://github.com/kube-hetzner/terraform-hcloud-kube-hetzner) to setup the k8s cluster on hetzner cloud.

To get started you need to copy `secrets.auto.tfvars.example` to `secrets.auto.tfvars` and fill the secrets.

## Setup

## Install

You need to have [opentofu](https://opentofu.org/) and [kubectl](https://kubernetes.io/docs/reference/kubectl/) installed.

## Update images

```sh
export HCLOUD_TOKEN=$(echo "nonsensitive(var.hcloud_token)" | terraform console -var-file secrets.auto.tfvars | sed -e 's/^"//' -e 's/"$//')

cd cluster/kube
curl -sL https://raw.githubusercontent.com/kube-hetzner/terraform-hcloud-kube-hetzner/master/packer-template/hcloud-microos-snapshots.pkr.hcl -o "hcloud-microos-snapshots.pkr.hcl"
packer init hcloud-microos-snapshots.pkr.hcl
packer build hcloud-microos-snapshots.pkr.hcl
```

## Run

### OpenTofu

```sh
tofu init --upgrade
tofu validate
tofu apply -auto-approve
```

### kubectl

Normally the kube config is created automatically. Otherwise you can get it via 
```sh
terraform output --raw kubeconfig > k3s_kubeconfig.yaml
```

Now you can use kubectl like this:
```sh
export KUBECONFIG="$(pwd)/k3s_kubeconfig.yaml"

kubectl version
```

#### Services

To apply a single service use 
```sh
kubectl apply -k services/hello
```

and to apply all you can use 

```sh
for service in services/*/; do
  kubectl apply -k $service
done
```

You can use following to delete services

```sh
kubectl delete -k services/hello
```
