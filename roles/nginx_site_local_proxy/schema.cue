package nginx_site_local_proxy

import "mizunashi.work/pkg/cue_types"

#LocalProxyEntry: {
  upstream_port: uint
  auth_password: cue_types.#Vaulted
}

nginx_site_local_proxy_listen_port: uint | *19100

nginx_site_local_proxy_entries: [string]: #LocalProxyEntry
