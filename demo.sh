#!/usr/bin/env bash

ENV_FILE_PATH="$(pwd)/.env"
source ${ENV_FILE_PATH}

## Cluster Status
echo
echo
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Current cluster status of namespace and pods"
echo "________________________________________________________________________________________________________________"
kubectx orbstack
kubectl get ns

## Sleep 60s
echo
echo
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Sleeping for 60s"
echo "________________________________________________________________________________________________________________"
sleep 1s

## Terraform execution
echo
echo
cd ${TERRAFORM_PATH}
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Current path $(pwd)"
echo "________________________________________________________________________________________________________________"
terraform init -reconfigure
terraform apply -auto-approve

## Argocd URL
echo
echo
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Argocd URL: "
echo "________________________________________________________________________________________________________________"
echo "https://localhost:30443"
## Get initial admin password
echo
echo
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Get initial admin password"
echo "________________________________________________________________________________________________________________"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

## Check demo app status
echo
echo
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Check demo app status"
echo "________________________________________________________________________________________________________________"
URL="localhost:30090"

while true; do
  # Run the curl command and suppress errors
  RESPONSE=$(curl --silent --show-error "$URL" 2>/dev/null)

  # If the curl command returns output, print it
  if [ ! -z "$RESPONSE" ]; then
    echo "Response: $RESPONSE"

    # Ask the user if they want to continue or quit
    read -p "Do you want to continue? (y/n): " choice

    if [ "$choice" != "y" ]; then
      echo "Exiting the loop..."
      break  # Exit the loop if the user says "n"
    fi
  else
    # Wait for 10 seconds before running the next curl command
    sleep 10
  fi
done

## Cluster Status
echo
echo
echo "________________________________________________________________________________________________________________"
echo "[SRE-INFO] - $(date) - Current cluster status of namespace and pods"
echo "________________________________________________________________________________________________________________"
kubectx orbstack
kubectl get ns
