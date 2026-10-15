# Todo App

Kubernetes deployment of the Go To-Do application.

A hands-on project for learning Kubernetes, infrastructure automation, and container orchestration.

## Overview

The project uses **Terraform** to provision infrastructure on Hetzner Cloud and **K3s** to run a lightweight Kubernetes cluster. It also includes a containerized Todo application deployed using Kubernetes manifests.

## Tech Stack

* **Hetzner Cloud** — cloud infrastructure
* **Terraform** — infrastructure as code
* **K3s / Kubernetes** — container orchestration
* **Nginx Ingress Controller** — external application access
* **React** — Frontend
* **Node.js** — Backend API
* **MongoDB** — Database

## Getting Started

### Prerequisites

* Hetzner Cloud account
* Terraform >= 1.5
* `kubectl`
* SSH key configured in Hetzner Cloud

### Deploy the Infrastructure

Navigate to the Terraform directory and follow the infrastructure deployment configuration:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Deploy the Todo App

Once the Kubernetes cluster is ready, apply the application manifests:

```bash
kubectl apply -R -f apps/todo-app/manifests/
```

Check the deployment status:

```bash
kubectl get nodes
kubectl get pods -n todo-app
kubectl get services -n todo-app
```

## Project Goals

* Practice infrastructure as code with Terraform.
* Deploy and manage applications on Kubernetes.
* Configure networking and external access using Nginx Ingress.
* Manage application configuration, secrets, and persistent storage.
* Learn monitoring and automation practices.
