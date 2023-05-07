package nftables

nftables_accept_tcp_ports: [...uint]
nftables_accept_ports_with_iif: [string]: #AcceptPortsWithIif
nftables_outbound_logging_filter_entries: [string]: #OutboundLoggingAndFilterEntry

#AcceptPortsWithIif: {
  iif: string
  tcp_ports: [...uint]
  udp_ports: [...uint]
}

#OutboundLoggingAndFilterEntry: {
  oif: string
  daddr: string
  tcp_dports: [...uint]
  udp_dports: [...uint]
}
