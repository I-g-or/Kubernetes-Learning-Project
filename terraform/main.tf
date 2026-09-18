resource "hcloud_server" "k3s" {
  name        = var.hcloud_server_name
  server_type = var.hcloud_server_type
  image       = var.hcloud_server_image
  location    = var.hcloud_server_location

  ssh_keys = [
    hcloud_ssh_key.k3s.id
  ]

  labels = {
    role        = "k3s"
    environment = "training"
  }
}