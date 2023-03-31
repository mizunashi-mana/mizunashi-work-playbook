package nginx_site_local_proxy

#LocalProxyEntry: {
  upstream_port: uint
}

nginx_site_local_proxy_listen_port: uint
nginx_site_local_proxy_common_domain: string

nginx_site_local_proxy_entries: [string]: #LocalProxyEntry
