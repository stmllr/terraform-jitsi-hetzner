# Terraform Jitsi Meet Server + Monitoring Server on Hetzner

## What does it do?

The terraform files allow you to create two Hetzner vservers from scratch:
1. A public Jitsi Meet instance (with a single jvb)
2. A public Grafana instance (with InfluxDB) for statistics

Features:
* Ready to use Jitsi Meet instance
* Jitsi metrics visualized with Grafana dashboard
* Letsencrypt SSL certs for both stats ans jitsi
* Debian based

Telegraf collects and sends Jitsi metrics to the InfluxDB.
Anonymous Grafana stats of the Jitsi
are public by default. However no private data is being published.
Even nginx logs are anonymized.

The current setup uses a minimalistic vserver instance type "cx11".
You'd probably need greater CPU power to server more than 3-4 participants.
Dedicated vservers are known to serve much better.

## What does it require?

* Hetzner API key
* Pregenerated SSH host keys in `.ssh/` directory
* Some tf variables (see below)
* Full qualified DNS names for the jitsi and the grafana host
* Full qualified DNS names for the floating IPs, one for the jitsi (aka lucio) and one for the stats host (aka tito)
* Floating IPs need to be setup in advance.

## Installation

1. Add your Hetzner API key to `~/.hetzner/jitsi-credentials`
Make sure there is no trailing newline (`0x0a` byte) at the end of the file.
Otherwise terraform will complain that the length is not 64 bytes.

2. Adapt the following lines to your personal preferences and add them to `./terraform.tfvars` file:
```tfvars
ssh_public_key_file = "PATH_TO_YOUR_PUBLIC_SSH_KEY.pub"
letsencrypt_mail = "EMAIL_ADDRESS"

fqdn = {
  meet  = "meet.example.com"
  stats = "stats.example.com"
  tito  = "tito.example.com"
  lucio = "lucio.example.com"
}
```

3. Create the infrastructure
```
terraform apply
```

## Known issues

* Testing. Does it work out of the box for you?
* Fix automatic Certbot renewal of SSL certificates
* Update grafana jitsi dashboard plugin
* tf output the generated grafana admin password
* Update to Debian buster
* Scaling needs separate jvb vservers
* Remove PTR DNS for the floating IPs. Are they required?
