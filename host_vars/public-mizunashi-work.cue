import "mizunashi.work/pkg/cue_vars/vagrant:hosts"
import "mizunashi.work/pkg/cue_vars/vagrant:ids"
import "mizunashi.work/pkg/schemas:host_vars"

let Schema = close({
  host_vars
})

#HostEntry: hosts.#host_entries.public001

Schema & {
  network_hostname: #HostEntry.host

  network_public_iface: hosts.#network_public_iface

  network_public_ipv4_address: "\(#HostEntry.public_ipv4_address)/\(#HostEntry.public_ipv4_netmask)"
  network_public_ipv4_gateway: #HostEntry.public_ipv4_gateway
  network_public_ipv4_nameserver: hosts.#dns_resolver_primary_ipv4

  network_public_ipv6_address: "\(#HostEntry.public_ipv6_address)/\(#HostEntry.public_ipv6_netmask)"
  if (*#HostEntry.public_ipv6_gateway | null) != null {
    network_public_ipv6_gateway: #HostEntry.public_ipv6_gateway
  }

  network_internal_iface: hosts.#network_internal_iface

  network_internal_hostname: #HostEntry.internal_host
  network_internal_ipv6_address: "\(#HostEntry.internal_ipv6_address)/\(ids.#internal_ipv6_netmask)"
}
