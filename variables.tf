variable "letsencrypt_mail" {
  type = string
}

variable "ssh_public_key_file" {
  type = string
}

variable "fqdn" {
  type = map(string)
}
