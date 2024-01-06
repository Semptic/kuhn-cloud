apiVersion: v1
kind: Namespace
metadata:
  name: tailscale
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: tailscale
  namespace: tailscale
spec:
  chart: tailscale-operator
  repo: https://pkgs.tailscale.com/helmcharts
  targetNamespace: tailscale
  valuesContent: |
    oauth:
      clientId: ${tailscale_client_id}
      clientSecret: ${tailscale_secret}