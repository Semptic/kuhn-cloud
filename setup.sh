#!/usr/bin/env bash

set -e

./with_secrets.sh apply setup/user
./with_secrets.sh apply setup/tailscale
./with_secrets.sh apply setup/monitoring

./with_secrets.sh apply setup/kubernetes-dashboard
./with_secrets.sh apply setup/longhorn
./with_secrets.sh apply setup/smb-storage-box