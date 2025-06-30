#!/bin/bash

set -e

echo "🧹 Deleting K3d cluster..."
k3d cluster delete iot-cluster || echo "No cluster found."

echo "🗑️ Removing all Docker containers, networks, images, and volumes created by K3d..."
docker system prune -a --volumes -f

if kubectl cluster-info > /dev/null 2>&1; then
    echo "🧽 Deleting Kubernetes namespaces if any are left..."
    kubectl delete namespace argocd --ignore-not-found
    kubectl delete namespace dev --ignore-not-found
else
    echo "⚠️ Skipping namespace deletion — Kubernetes cluster is already down."
fi


echo "🧼 remove binaries"
sudo rm -f /usr/local/bin/k3d
sudo rm -f /usr/local/bin/kubectl

echo "✅ Cleanup complete!"

