import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/schemas/host_vars"

let vars = vagrant

#Schema: host_vars

#Schema & {
  base_internal_hostname: vars.#host_entries.internal001.internal_host
}
