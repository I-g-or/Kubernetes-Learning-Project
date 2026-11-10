This folder contains scripts that automatically deploy the Todo application after the K3s cluster is ready.

These scripts are called from the cloud-init `user_data` when Terraform creates the Hetzner Cloud virtual machine.

## How it works

1. Terraform creates a VM and runs cloud-init.
2. cloud-init installs K3s, Helm and clones this repository.
3. cloud-init run chooses the deployment method. The deployment method is controlled by the environment variable `$METHOD` (by default "helm") 