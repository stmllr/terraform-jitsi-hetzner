provider "hcloud" {
# It is required to truncate trailing 0a character from the token (using hexedit)
# otherwise terraform complains that the token is not 64 byte
  token = file("~/.hetzner/jitsi-credentials")
}

variable "influx_ip_address" {
  type = string
  default = "10.0.0.2"
}

module "private_network" {
  source = "./private_network"
}

module "tito_ip" {
  source = "./floating_ip"
  ptr    = var.fqdn["tito"]
}

module "lucio_ip" {
  source = "./floating_ip"
  ptr    = var.fqdn["lucio"]
}

module "monitoring_server" {
  source = "./monitoring_server"
  name = "stats"
  server_image = "debian-10"
  server_type = "cx11"

  floating_ip = module.tito_ip.floating_ip
  fqdn = var.fqdn["stats"]
  letsencrypt_mail = var.letsencrypt_mail
  ssh_public_key = file(var.ssh_public_key_file)

  private_ip_address = var.influx_ip_address
  monitoring_subnet_id = module.private_network.monitoring_subnet.id

  depends_on = [module.private_network, module.tito_ip]
}

module "meet_server" {
  source = "./jitsi_meet_server"
  name = "meet"
  server_image = "debian-10"
  server_type = "cx11"

  influx_ip_address = var.influx_ip_address
  floating_ip = module.lucio_ip.floating_ip
  fqdn = var.fqdn["meet"]
  letsencrypt_mail = var.letsencrypt_mail
  ssh_public_key = file(var.ssh_public_key_file)

  monitoring_subnet_id = module.private_network.monitoring_subnet.id

  depends_on = [module.monitoring_server, module.private_network, module.lucio_ip]
}
