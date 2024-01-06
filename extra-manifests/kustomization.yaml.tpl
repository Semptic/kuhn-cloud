apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization


resources:
  - cert-manager-webhook-inwx.yaml
  - smb-storage-box.yaml
  - tailscale.yaml