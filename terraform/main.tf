resource "hcloud_server" "k3s" {
  name        = var.hcloud_server_name
  server_type = var.hcloud_server_type
  image       = var.hcloud_server_image
  location    = var.hcloud_server_location

  ssh_keys = [
    hcloud_ssh_key.k3s.id
  ]

  user_data = <<-EOF
#cloud-config
package_update: true
package_upgrade: true

packages:
  - curl
  - apt-transport-https
  - ca-certificates
  - git

runcmd:
  - sleep 10
  # === Install Kubernetes ===
  - |
    curl -sfL https://get.k3s.io | \
    INSTALL_K3S_EXEC="server \
      --write-kubeconfig-mode 644 \
      --tls-san $(curl -s http://169.254.169.254/hetzner/v1/metadata/public-ipv4) \
      --disable=traefik" \
    sh -
  - mkdir -p /root/.kube
  - cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
  - chmod 600 /root/.kube/config
  - echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> /root/.bashrc
  - echo 'alias k=kubectl' >> /root/.bashrc
  - |
    echo "Waiting for K3s to be ready..."
    for i in $(seq 1 60); do
      if kubectl get nodes 2>/dev/null | grep -q Ready; then
        echo "K3s is ready!"
        break
      fi
      echo "Attempt $i/60: K3s not ready yet..."
      sleep 5
    done

  - |
    mkdir -p ~/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
    sudo chown $(id -u):$(id -g) ~/.kube/config
    sudo chmod 600 ~/.kube/config

  # === Install Helm ===
  - | 
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
    chmod 700 get_helm.sh
    ./get_helm.sh

  # === Download Kubernetes Learning Project ===
  - git clone https://github.com/I-g-or/Kubernetes-Learning-Project.git /opt/Kubernetes-Learning-Project
  - |
    PUBLIC_IP=$(curl -s http://169.254.169.254/hetzner/v1/metadata/public-ipv4)
    echo "Public IP: $PUBLIC_IP"
    export PUBLIC_IP

# === Select deployment method ===
# manifests: triggering a deployment based on a Kubernetes manifest
# helm: triggering a deployment based on a Helm chart
  - |
    METHOD="helm"  # Default method

    echo "Deployment method selected: $METHOD"
    case "$METHOD" in
      helm)
        bash /opt/Kubernetes-Learning-Project/scripts/deploy-helm.sh
        ;;
      manifests)
        bash /opt/Kubernetes-Learning-Project/scripts/deploy-manifests.sh
        ;;
      *)
        echo "Unknown method: $METHOD"
        exit 1
        ;;
    esac
EOF
  # - mkdir -p /root/apps/2048
  # - |
  #   echo "Downloading 2048 manifest from GitHub..."
  #   curl -sfL \
  #     https://raw.githubusercontent.com/I-g-or/Kubernetes-Learning-Project/feature/hetzner-infrastructure/apps/2048/2048.yml \
  #     -o /root/apps/2048/2048.yml
  # - |
  #   echo "Deploying 2048 application..."
  #   kubectl apply -f /root/apps/2048/2048.yml
  #   echo "2048 application deployed successfully!"
  # - kubectl get all -n game-2048


  labels = {
    role        = "k3s"
    environment = "training"
  }
}