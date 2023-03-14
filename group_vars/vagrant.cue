import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"
import "mizunashi.work/pkg/roles/nginx"
import "mizunashi.work/pkg/roles/nginx_exporter"
import "mizunashi.work/pkg/roles/nginx_site_http_redirector"
import "mizunashi.work/pkg/roles/nginx_site_mastodon"
import "mizunashi.work/pkg/roles/postgresql_mastodon"

#Schema: fail2ban
#Schema: nftables
#Schema: openssh_server
#Schema: nginx
#Schema: nginx_exporter
#Schema: nginx_site_http_redirector
#Schema: nginx_site_mastodon
#Schema: postgresql_mastodon

let mastodon_domain = "primary.mizunashi-work.vagrant"
let ssh_port = 22
let http_port = 80
let https_port = 443

#Schema & {
  nginx_site_mastodon_server_name: mastodon_domain

  postgresql_mastodon_workuser_password: "password"

  openssh_server_listen_port: ssh_port
  nginx_site_http_redirector_listen_port: http_port
  nginx_site_mastodon_listen_port: https_port

  nftables_accept_tcp_ports: [
    ssh_port,
    http_port,
    https_port,
  ]

  nginx_resolver: "8.8.8.8"
}
