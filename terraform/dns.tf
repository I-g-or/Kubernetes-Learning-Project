resource "hcloud_zone" "igor1" {
  name = "igor1.pp.ua"
  mode = "primary"
}

resource "hcloud_zone_rrset" "root_a" {
  zone = hcloud_zone.igor1.name
  name = "@"
  type = "A"
  ttl  = 300

  records = [
    {
      value   = hcloud_server.k3s.ipv4_address
      comment = "Kubernetes Ingress"
    }
  ]
}
