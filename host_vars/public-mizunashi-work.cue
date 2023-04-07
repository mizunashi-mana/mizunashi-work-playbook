import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/schemas/host_vars"

let vars = vagrant
let host_entry = vars.#host_entries.public001

#Schema: host_vars

#Schema & {
  network_internal_hostname: host_entry.internal_host
  network_internal_address: host_entry.internal_ip
}
