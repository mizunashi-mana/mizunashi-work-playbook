import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/schemas/host_vars"

let vars = vagrant
let host_entry = vars.#host_entries.internal001

#Schema: host_vars

#Schema & {
  network_hostname: host_entry.host

  network_public_ipv4_address: host_entry.public_ipv4_address
  network_public_ipv4_netmask: host_entry.public_ipv4_netmask
  network_public_ipv4_nameserver: vars.#public_dns_resolver_ipv4
  network_public_ipv4_search: vars.#primary_domain_ipv4

  network_public_ipv6_address: host_entry.public_ipv6_address
  network_public_ipv6_netmask: host_entry.public_ipv6_netmask
  network_public_ipv6_nameserver: vars.#public_dns_resolver_ipv6
  network_public_ipv6_search: vars.#primary_domain_ipv6

  network_internal_hostname: host_entry.internal_host
  network_internal_ipv4_address: host_entry.internal_ipv4
}
