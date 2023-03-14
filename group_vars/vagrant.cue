import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"
import "mizunashi.work/pkg/roles/nginx"
import "mizunashi.work/pkg/roles/mastodon"
import "mizunashi.work/pkg/roles/nginx_exporter"
import "mizunashi.work/pkg/roles/nginx_site_http_redirector"
import "mizunashi.work/pkg/roles/nginx_site_mastodon"
import "mizunashi.work/pkg/roles/postgresql_mastodon"

#Schema: fail2ban
#Schema: nftables
#Schema: openssh_server
#Schema: nginx
#Schema: mastodon
#Schema: nginx_exporter
#Schema: nginx_site_http_redirector
#Schema: nginx_site_mastodon
#Schema: postgresql_mastodon

let mastodon_domain = "primary.mizunashi-work.vagrant"
let ssh_port = 22
let http_port = 80
let https_port = 443

#Schema & {
  mastodon_local_domain: mastodon_domain
  mastodon_single_user_mode: "true"

  mastodon_workuser_password: "password"

  mastodon_secret_key_base: "5e652f27c7a2b2008c32dfabf2cb3cd72c2ad1d1799234802d37fd70f1ede01f35a8b4ab83a734d911b0c6a83e149e6e2430e36861fab3b994ab30f5addffa32"
  mastodon_otp_secret: "0e79d3b21a74012561f798139f8f224287ee74a7a314374f57361fa65b157be040b03e945affe576ca0883cb3e16ab45e374747757709b82008f8fddc6437958"

  mastodon_vapid_private_key: "Q4gwojc2ftWh2b-mScgvNyKTO7iDf0H878BaBhBCaqU="
  mastodon_vapid_public_key: "BMRVNeG8Io07OP2yGLhhhIXiX-m7Tjjhws_RJ9b1BvBXTKj8wRn9XAyRBoeM04TUgj26qkdnrtBbcRh_XODZW3k="

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
