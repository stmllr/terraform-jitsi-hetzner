variable "name" {
  description = "vServer name"
  type        = string
}

variable "server_image" {
  description = "vServer image"
  type        = string
}

variable "server_type" {
  description = "vServer type"
  type        = string
}

variable "influx_ip_address" {
  description = "Private IP address of the influx DB server"
  type        = string
}

variable "monitoring_subnet_id" {
  description = "Private subnet for monitoring"
  type        = string
}

variable "floating_ip" {
  description = "Floating (Public) IP address (object)"
  type        = object({
    ip_address = string,
    id: number
  })
}

variable "fqdn" {
  description = "Full qualified domain name of the host"
  type        = string
}

variable "letsencrypt_mail" {
  description = "E-mail address for letsencrypt"
  type        = string
}

variable "ssh_public_key" {
  description = "Public ssh key for admin"
  type        = string
}
