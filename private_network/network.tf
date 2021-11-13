resource "hcloud_network" "private" {
  name = "private_network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "monitoring" {
  network_id = hcloud_network.private.id
  type = "cloud"
  network_zone = "eu-central"
  ip_range   = "10.0.0.0/24"
}
