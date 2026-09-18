resource "hcloud_ssh_key" "k3s" {
  name       = "k3s-training"
  public_key = var.ssh_public_key
}
