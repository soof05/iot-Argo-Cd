#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"


set -e

echo "🧰 Updating and installing dependencies..."
sudo apt update && sudo apt install -y curl wget apt-transport-https gnupg lsb-release ca-certificates

echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | bash
    sudo usermod -aG docker $USER
    echo "🚀 Docker installed. You might need to log out and back in for permissions to apply."
else
    echo "✅ Docker already installed."
fi

echo "📦 Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
else
    echo "✅ kubectl already installed."
fi

echo "📦 Installing K3d..."
if ! command -v k3d &> /dev/null; then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "✅ K3d already installed."
fi

echo "🛠 Creating K3d cluster..."
k3d cluster create iot-cluster"

echo "🔧 Setting kubeconfig context..."
export KUBECONFIG="$(k3d kubeconfig write iot-cluster)"

echo "📂 Creating namespaces..."
kubectl create namespace argocd || echo "Namespace argocd already exists"
kubectl create namespace dev || echo "Namespace dev already exists"

echo "🚀 Installing Argo CD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "⏳ Waiting for Argo CD pods to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# password to argocd (user: admin)
echo -n "${GREEN}ARGOCD PASSWORD : "
  sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo "${RESET}"

echo "✅ Setup complete!"
echo "📌 You can now access Argo CD with:"
echo "   kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "🌐 Then open https://localhost:8080"
