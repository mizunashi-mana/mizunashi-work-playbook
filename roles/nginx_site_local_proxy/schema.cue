package nginx_site_local_proxy

import "mizunashi.work/pkg/cue_types"

import "mizunashi.work/pkg/roles/private_root_ca"

nginx_site_local_proxy_listen_port: uint | *19100
nginx_site_local_proxy_acme_challenge_url: string
nginx_site_local_proxy_ca_bundle_path: private_root_ca.private_root_ca_certificate_path

nginx_site_local_proxy_entries: [string]: #LocalProxyEntry

#LocalProxyEntry: {
  upstream_port: uint
  auth_password: cue_types.#Vaulted
}
