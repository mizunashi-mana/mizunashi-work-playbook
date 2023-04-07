import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/schemas/host_vars"

#Schema: host_vars

#Schema & {
  base_internal_hostname: vagrant.#host_entries.public001.internal_host
}
