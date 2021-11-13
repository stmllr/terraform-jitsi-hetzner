resource "hcloud_server" "jitsi_meet" {
  name = var.name
  image = var.server_image
  server_type = var.server_type
  location = "nbg1"
  keep_disk = true
  user_data = templatefile("./jitsi_meet_server/cloud-init.yml", {
    fqdn = var.fqdn
    public_ip_address = var.floating_ip.ip_address
    influx_ip_address = var.influx_ip_address
    letsencrypt_mail = var.letsencrypt_mail
    ssh_public_key = var.ssh_public_key
    ssh_host_rsa_key = file(".ssh/ssh_host_rsa_key")
    ssh_host_rsa_key_pub = file(".ssh/ssh_host_rsa_key.pub")
    ssh_host_dsa_key = file(".ssh/ssh_host_dsa_key")
    ssh_host_dsa_key_pub = file(".ssh/ssh_host_dsa_key.pub")
    ssh_host_ecdsa_key = file(".ssh/ssh_host_ecdsa_key")
    ssh_host_ecdsa_key_pub = file(".ssh/ssh_host_ecdsa_key.pub")
    ssh_host_ed25519_key = file(".ssh/ssh_host_ed25519_key")
    ssh_host_ed25519_key_pub = file(".ssh/ssh_host_ed25519_key.pub")
  })

  lifecycle {
    ignore_changes = [user_data]
  }

  labels = {
    terraform = "true"
    node = var.name
  }
}

resource "hcloud_floating_ip_assignment" "jitsi_meet" {
  server_id = hcloud_server.jitsi_meet.id
  floating_ip_id = var.floating_ip.id
}

resource "hcloud_server_network" "private_monitoring" {
  server_id = hcloud_server.jitsi_meet.id
  subnet_id = var.monitoring_subnet_id
}
