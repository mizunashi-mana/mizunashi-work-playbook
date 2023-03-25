package nginx_site_local_proxy

#ProxyEntry: {
  upstream_port: uint
}

nginx_site_local_proxy_listen_port: uint
// nginx_site_local_proxy_ssl_client_certificate: cue_types.#Vaulted

nginx_site_local_proxy_entries: [string]: #ProxyEntry
