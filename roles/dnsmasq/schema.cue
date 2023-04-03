package dnsmasq

dnsmasq_listen_port: uint | *53

dnsmasq_hosts_entries: [...#HostEntry]

#HostEntry: {
  domain: string
  ip: string
}
