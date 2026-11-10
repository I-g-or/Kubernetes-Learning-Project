#!/bin/bash
set -euo pipefail

echo "Deploying application..."
kubectl apply -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/namespace.yml
kubectl apply --server-side --force-conflicts -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/monitoring/prometheus/prometheus-operator.yml
kubectl wait --for=condition=Established crd/prometheuses.monitoring.coreos.com --timeout=60s
kubectl wait --for=condition=Established crd/servicemonitors.monitoring.coreos.com --timeout=60s
kubectl apply -R -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/monitoring/
kubectl apply -R -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/db/
kubectl wait --for=condition=Ready pod \
    -l app=mongodb \
    -n todo-app \
    --timeout=300s
kubectl apply -R -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/backend/
kubectl apply -R -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/frontend/
kubectl apply -R -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/ingress/deploy.yml
kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=300s
kubectl apply -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/cert-manager/cert-manager.yml
kubectl wait --namespace cert-manager \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/instance=cert-manager \
        --timeout=300s
kubectl apply -R -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/cert-manager/cluster-issuer.yml
kubectl apply -R -f /opt/Kubernetes-Learning-Project/apps/todo-app/manifests/ingress/ingress.yml