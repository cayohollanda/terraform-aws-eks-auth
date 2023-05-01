#!/bin/bash

map_roles_json=$1
module_path=$2

# Get actually configmap manifest
kubectl get configmap aws-auth -n kube-system -o yaml > aws-auth.yaml

# Making a copy of configmap (generating a backup)
cp aws-auth.yaml aws-auth.yaml.bak

# Calling Python script to update the configmap
python3 "${module_path}/update_configmap.py" "${map_roles_json}"

# Applying the manifest with the new roles
kubectl apply -f aws-auth_updated.yaml >> update.log

# Conditional to print if the proccess was successfully or not
if grep -q "configmap/aws-auth configured" update.log; then
  echo "ConfigMap successfully updated"
  rm aws-auth.yaml aws-auth.yaml.bak aws-auth_updated.yaml update.log
  exit 0
else
  echo "ERROR: Failed to update aws-auth configmap"
  rm aws-auth.yaml aws-auth.yaml.bak aws-auth_updated.yaml update.log
  exit 1
fi