package dnsmasq

dnsmasq_listen_port: uint | *53

dnsmasq_hosts_entries: [string]: #HostEntry

#HostEntry: {
  primary_host: string
  additional_hosts: [...string]
}
