#!/usr/bin/env bash

ENV_FILE_PATH="$(pwd)/.env"
source ${ENV_FILE_PATH}

## Terraform destroy
echo
echo
cd ${TERRAFORM_PATH}
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Current path $(pwd)"
echo "________________________________________________________________________________________________________________"
terraform destroy -auto-approve

## Namespace cleanup
echo
echo
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Delete demo app namespace"
echo "________________________________________________________________________________________________________________"
kubectx orbstack
if kubectl get namespace "${DEMO_APP_NAMESPACE}" >/dev/null 2>&1; then
  kubectl delete ns demo-app --force --grace-period 0
fi

## Cluster Status
echo
echo
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Current cluster status of namespace and pods"
echo "________________________________________________________________________________________________________________"
kubectx orbstack
kubectl get ns