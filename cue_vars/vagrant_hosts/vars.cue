package vagrant_hosts

import "mizunashi.work/pkg/cue_vars/vagrant_ids"

let ids = vagrant_ids

#primary_domain_ipv4: "mizunashi-work.vagrant"
#primary_domain_ipv6: "mizunashi-work.vagrant"

#internal_host_entries: {
  internal001: {
    host: "internal.\(#primary_domain_ipv4)"

    public_ipv4_address: "192.168.61.34"
    public_ipv4_gateway: "10.0.2.2"
    public_ipv4_netmask: "255.255.255.0"

    public_ipv6_address: "fde4:8dba:82e1:1005::34"
    public_ipv6_netmask: "64"

    internal_host: "internal001.\(ids.#private_domain)"
    internal_ipv6_address: "\(ids.#internal_ipv6_prefix64)::1001"
  }
}

#public_host_entries: {
  public001: {
    host: "public.\(#primary_domain_ipv4)"

    public_ipv4_address: "192.168.61.33"
    public_ipv4_gateway: "10.0.2.2"
    public_ipv4_netmask: "255.255.255.0"

    public_ipv6_address: "fde4:8dba:82e1:1005::33"
    public_ipv6_netmask: "64"

    internal_host: "public001.\(ids.#private_domain)"
    internal_ipv6_address: "\(ids.#internal_ipv6_prefix64)::1002"
  }
}

#host_entries: {
  for host, entry in #internal_host_entries {
    "\(host)": entry
  }
  for host, entry in #public_host_entries {
    "\(host)": entry
  }
}

#dns_resolver_primary_ipv4: "4.2.2.1"
#dns_resolver_primary_ipv6: "2001:4860:4860::8844"
#dns_resolvers_secondary_ipv4: [
  "4.2.2.2",
]

#network_public_iface: "eth1"
#network_internal_iface: "eth2"
