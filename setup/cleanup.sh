#!/bin/bash

set -e

echo "🧼 Deleting Kubernetes namespaces..."

# Delete Argo CD namespace
if kubectl get namespace argocd &> /dev/null; then
    kubectl delete namespace argocd
    echo "✅ Namespace 'argocd' deleted."
else
    echo "⚠️ Namespace 'argocd' does not exist."
fi

# Delete dev namespace
if kubectl get namespace dev &> /dev/null; then
    kubectl delete namespace dev
    echo "✅ Namespace 'dev' deleted."
else
    echo "⚠️ Namespace 'dev' does not exist."
fi

echo "🧨 Deleting k3d cluster 'iot-cluster'..."
if k3d cluster get iot-cluster &> /dev/null; then
    k3d cluster delete iot-cluster
    echo "✅ Cluster 'iot-cluster' deleted."
else
    echo "⚠️ Cluster 'iot-cluster' does not exist."
fi

echo "🧹 Cleanup complete. Docker and k3d are still installed."
