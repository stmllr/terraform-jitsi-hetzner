output "private_network_id" {
  value = hcloud_network.private.id
}

output "monitoring_subnet" {
  value = hcloud_network_subnet.monitoring
}
