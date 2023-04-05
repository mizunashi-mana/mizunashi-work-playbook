package nftables

nftables_accept_tcp_ports: [...uint]
nftables_accept_ports_with_iif: [string]: #AcceptPortsWithIif

#AcceptPortsWithIif: {
  iif: string
  tcp_ports: [...uint]
  udp_ports: [...uint]
}
