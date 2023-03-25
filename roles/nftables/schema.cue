package nftables

#AcceptPortsWithAddrs: {
  source_addrs: [...string]
  tcp_ports: [...uint]
}

nftables_accept_tcp_ports: [...uint]
nftables_accept_ports_with_addrs: [string]: #AcceptPortsWithAddrs
