#!/bin/bash
set -euo pipefail

# === Deploy Todo application using Helm ===
# 1. NGINX Ingress Controller - official Helm chart
# 2. cert-manager - official Helm chart
# 3. MongoDB  - Bitnami chart
# 4. Backend  - local chart: todo-backend
# 5. Frontend - local chart: todo-frontend
# 6. Ingress + ClusterIssuers

REPO_ROOT="/opt/Kubernetes-Learning-Project"
CHARTS_DIR="${REPO_ROOT}/apps/todo-app/helm"
NAMESPACE="todo-app"
HOST="igor1.pp.ua"

kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

# === Install NGINX Ingress Controller ===
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer \
  --wait \
  --timeout 5m

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

# === Install cert-manager ===
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true \
  --wait \
  --timeout 5m

kubectl wait --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/instance=cert-manager \
  --timeout=300s

# === Install MongoDB from Bitnami === 
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install mongodb bitnami/mongodb \
  --namespace "${NAMESPACE}" \
  --set architecture=standalone \
  --set auth.rootUser=root \
  --set auth.rootPassword=todoapp \
  --set auth.username=todoapp \
  --set auth.password=todoapp \
  --set auth.database=todoapp \
  --set persistence.size=5Gi \
  --set service.nameOverride=mongodb \
  --wait \
  --timeout 5m

kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=mongodb \
  -n "${NAMESPACE}" \
  --timeout=300s

# === Install todo-app backend chart ===
helm upgrade --install todo-backend "${CHARTS_DIR}/backend" \
  --namespace "${NAMESPACE}" \
  --set image.repository=abdennour/go-to-do-api \
  --set image.tag=rc \
  --set env.DB_CONNECTION="mongodb://todoapp:todoapp@mongodb:27017/todoapp" \
  --set env.DB_NAME=todoapp \
  --wait \
  --timeout 3m

# === Install todo-app frontend chart ===
helm upgrade --install todo-frontend "${CHARTS_DIR}/frontend" \
  --namespace "${NAMESPACE}" \
  --set image.repository=abdennour/go-to-do-frontend \
  --set image.tag=rc \
  --set env.REACT_APP_API_ENDPOINT="https://${HOST}" \
  --wait \
  --timeout 3m

# === Ingress + ClusterIssuers ===
helm upgrade --install todo-ingress "${CHARTS_DIR}/ingress" \
  --namespace "${NAMESPACE}" \
  --set host="${HOST}" \
  --set clusterIssuer=letsencrypt-prod \
  --set backend.serviceName=backend \
  --set frontend.serviceName=frontend \
  --wait \
  --timeout 2m

echo "=============================================="
echo " Helm deployment finished successfully!"
echo "=============================================="
echo ""
echo "Releases:"
helm list -n "${NAMESPACE}"
echo ""
echo "Pods:"
kubectl get pods -n "${NAMESPACE}"
echo ""
echo "Ingress:"
kubectl get ingress -n "${NAMESPACE}"
echo ""
echo "ClusterIssuers:"
kubectl get clusterissuer
echo ""
echo "App URL: https://${HOST}"