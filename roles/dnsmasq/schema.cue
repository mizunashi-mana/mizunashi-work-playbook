package dnsmasq

import "mizunashi.work/pkg/roles/systemd_resolved"

systemd_resolved

systemd_resolved_stub_listener: false

dnsmasq_listen_port: uint | *53

dnsmasq_hosts_entries: [...#HostEntry]

#HostEntry: {
  domain: string
  ip: string
}
