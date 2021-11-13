resource "hcloud_floating_ip" "ip" {
  name = var.ptr
  type = "ipv4"
  home_location = "nbg1"
  labels = {
    terraform = "true"
  }
}

resource "hcloud_rdns" "rdns" {
  floating_ip_id = hcloud_floating_ip.ip.id
  ip_address = hcloud_floating_ip.ip.ip_address
  dns_ptr = var.ptr

  depends_on = [hcloud_floating_ip.ip]
}
