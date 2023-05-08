package nftables

nftables_accept_tcp_ports: [=~"^[0-9]+$"]: {}
nftables_accept_ports_with_iif: [string]: #AcceptPortsWithIif
nftables_outbound_logging_filter_entries: [string]: #OutboundLoggingAndFilterEntry

#AcceptPortsWithIif: {
  iif: string
  tcp_ports: [...uint]
  udp_ports: [...uint]
}

#OutboundLoggingAndFilterEntry: {
  oif: string
  ip_cond: {
    all: bool | *false
    ipv4_daddrs: [...string]
    ipv6_daddrs: [...string]
  }
  proto_cond: {
    icmp: bool | *false
    tcp_sports: [...uint]
    tcp_dports: [...uint]
    udp_sports: [...uint]
    udp_dports: [...uint]
  }
}
