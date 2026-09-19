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

runcmd:
  - sleep 10
  - |
    curl -sfL https://get.k3s.io | \
    INSTALL_K3S_EXEC="server \
      --write-kubeconfig-mode 644 \
      --disable traefik \
      --tls-san $(curl -s http://169.254.169.254/hetzner/v1/metadata/public-ipv4)" \
    sh -
  - mkdir -p /root/.kube
  - cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
  - chmod 600 /root/.kube/config
  - echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> /root/.bashrc
  - echo 'alias k=kubectl' >> /root/.bashrc
EOF

  labels = {
    role        = "k3s"
    environment = "training"
  }
}