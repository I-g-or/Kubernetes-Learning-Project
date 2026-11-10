#!/bin/bash
set -euo pipefail

# === Deploy Todo application using Helm ===
# 1. MongoDB  - Bitnami chart
# 2. Backend  - local chart: todo-backend
# 3. Frontend - local chart: todo-frontend

REPO_ROOT="/opt/Kubernetes-Learning-Project"
CHARTS_DIR="${REPO_ROOT}/apps/todo-app/helm"
NAMESPACE="todo-app"

kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

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
  --set env.REACT_APP_API_ENDPOINT="https://igor1.pp.ua" \
  --wait \
  --timeout 3m


echo "=============================================="
echo " Helm deployment finished successfully!"
echo "=============================================="
echo ""
echo "Releases:"
helm list -n "${NAMESPACE}"
echo ""
echo "Pods:"
kubectl get pods -n "${NAMESPACE}"