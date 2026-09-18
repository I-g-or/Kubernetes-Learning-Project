output "server_name" {
  value = hcloud_server.k3s.name
}

output "server_ipv4" {
  value = hcloud_server.k3s.ipv4_address
}