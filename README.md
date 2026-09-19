# Kubernetes Learning Project

Learning project for Kubernetes + K3s + Terraform + Ansible.

## What is available now

- Terraform creates **one** virtual machine in Hetzner Cloud
- **K3s** is automatically installed on this machine (Master + Worker on a single node)
- Ready for further Kubernetes practice

## Requirements

- Hetzner Cloud account
- Terraform >= 1.5
- SSH key

## How to run

### 1. Preparation

```bash
cd terraform