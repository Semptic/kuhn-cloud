#!/usr/bin/env bash

action=$1
service=$2

if [ -z "$action" ] || [ -z "$service" ]; then
  echo "Usage: $0 <apply|delete> <service>"
  exit 1
fi

if [ "$action" != "apply" ] && [ "$action" != "delete" ]; then
  echo "Invalid action: $action"
  echo "Usage: $0 <apply|delete> <service>"
  exit 1
fi

if [ ! -d "$service" ]; then
  echo "Service $service does not exist"
  echo "Usage: $0 <apply|delete> <service>"

  exit 1
fi

if [ ! -d "$service" ]; then
  echo "Service $service does not exist"
  echo "Usage: $0 <apply|delete> <service>"

  exit 1

fi

set -o allexport
source .secrets.env 
set +o allexport

tmpdir=$(mktemp -d)

# Define cleanup function
cleanup() {
  echo "Cleaning up..."
  rm -r $tmpdir
}

ls $tmpdir

for file in $service/*.yaml; do
  tmp_file=$tmpdir/$(basename $file)

  envsubst < $file > $tmp_file
done

kubectl $action -k $tmpdir