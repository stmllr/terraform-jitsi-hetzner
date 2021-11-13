resource "hcloud_server" "monitoring" {
  name = var.name
  image = var.server_image
  server_type = var.server_type
  location = "nbg1"
  keep_disk = true

  user_data = templatefile("./monitoring_server/cloud-init.yml", {
    fqdn = var.fqdn
    public_ip_address = var.floating_ip.ip_address
    private_ip_address = var.private_ip_address
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

    grafana_admin_passwd = "CHANGE_ME_${random_password.grafana_admin_passwd.result}"

    grafana_jitsi_dashboard = base64gzip(file("./monitoring_server/cloud-init/grafana_jitsi_dashboard.json"))
    grafana_provisioning = base64gzip(file("./monitoring_server/cloud-init/grafana_provisioning_dashboard_file.yaml"))
    influxdb_yaml = base64gzip(file("./monitoring_server/cloud-init/influxdb.yaml"))
    nginx_log_conf = base64gzip(file("./monitoring_server/cloud-init/nginx_log_conf"))
    sshd_config = base64gzip(file("./monitoring_server/cloud-init/sshd_config"))
  })

  lifecycle {
    ignore_changes = [user_data]
  }

  labels = {
    terraform = "true"
    node = "jitsi-stats"
  }
}

resource "random_password" "grafana_admin_passwd" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "hcloud_floating_ip_assignment" "monitoring" {
  server_id = hcloud_server.monitoring.id
  floating_ip_id = var.floating_ip.id
}

resource "hcloud_server_network" "private_monitoring" {
  server_id = hcloud_server.monitoring.id
  subnet_id = var.monitoring_subnet_id
  ip = var.private_ip_address
}
