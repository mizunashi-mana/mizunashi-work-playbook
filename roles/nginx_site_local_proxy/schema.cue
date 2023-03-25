package nginx_site_local_proxy

nginx_site_local_proxy_listen_port: uint
// nginx_site_local_proxy_ssl_client_certificate: cue_types.#Vaulted

#ProxyEntry: {
  path: string
  upstream_port: uint
}

nginx_site_local_proxy_entries: [string]: #ProxyEntry
