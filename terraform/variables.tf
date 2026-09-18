variable "hcloud_server_image" {
  description = "Hetzner Cloud server image"
  type        = string
  default     = "ubuntu-24.04"
}

variable "hcloud_server_name" {
  description = "Hetzner Cloud server name"
  type        = string
  default     = "k3s-node-01"
}
variable "hcloud_server_location" {
  description = "Hetzner Cloud location"
  type        = string
  default     = "nbg1"
}

variable "hcloud_server_type" {
  description = "Hetzner Cloud server type"
  type        = string
  default     = "cx12"
}

variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for Hetzner VM"
}