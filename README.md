# Raspberry Pi Setup
The setup for my docker apps running on a Raspberry Pi.

# Apps
* Forgejo
* Mealie
* Portainer

# Reverse proxy

## Requirements

- A domain provided by Cloudflare
- A api key created for the domain
- A Raspberry Pi to install everything to

## Docker setup

[https://docs.docker.com/engine/install/raspberry-pi-os/](https://docs.docker.com/engine/install/raspberry-pi-os/)

## Caddy

### To setup Caddy we first need to install it:

```shell
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
chmod o+r /usr/share/keyrings/caddy-stable-archive-keyring.gpg
chmod o+r /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy
```

[source](https://caddyserver.com/docs/install#debian-ubuntu-raspbian)

### Then we need to add the Cloudflare Module:

`/etc/caddy/Caddyfile`

```shell
sudo caddy add-package github.com/caddy-dns/cloudflare
```

[source](https://caddy.community/t/is-my-config-okay-or-do-i-need-to-install-the-cloudflare-module/24382/2)

### Next step we write the Caddyfile config:

```
(cloudflare-only) {
  @blocked not remote_ip 173.245.48.0/20 103.21.244.0/22 103.22.200.0/22 # more ips...
  respond @blocked "<h1>Access denied</h1>" 403
}

example.com {
	import cloudflare-only
	reverse_proxy :8080
	tls {
		cloudflare dns a1b2c3d4e5g6... # Api key
	}
}
```

[source](https://caddy.community/t/caddy-and-allowing-traffic-only-from-cloudflare-tutorial/20797)

### Test Caddy:

start Caddy

`caddy run`

adapt to Caddyfile

`caddy adapt --config /path/to/Caddyfile`

Or use

`caddy reload`

you can curl `:2019` to check the currently loaded config

### Caddy as service:

Stop any instances of Caddy running, then create a caddy.service file, copy from [here](https://github.com/caddyserver/dist/blob/master/init/caddy.service)

`/etc/systemd/system/caddy.service`

Then run the following commands

```shell
sudo systemctl daemon-reload
sudo systemctl enable --now caddy
```

Verify status:

```shell
systemctl status caddy
```

Read logs:

```shell
journalctl -u caddy --no-pager | less +G
```

Reload service (e.g. to adapt to new Caddyfile)

```shell
sudo systemctl reload caddy
```

[source](https://caddyserver.com/docs/running)

## Backup
I wrote multiple backup scripts for different containers in my setup. To use them you just need to rename: `.env.something->` `.env`
