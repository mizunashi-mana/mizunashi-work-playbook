import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/vagrant_private_ca"

import "mizunashi.work/pkg/roles/prometheus"

#Schema: vagrant
#Schema: prometheus

let ssh_port = vagrant.#ssh_port

let prometheus_phase = "vagrant"
let prometheus_group_internal = "internal"
let internal_vagrant_host = "internal.mizunashi-work.vagrant"

let internal_vagrant_labels = {
  phase: prometheus_phase
  group: prometheus_group_internal
  hostname: internal_vagrant_host
}

#Schema & {
  nftables_accept_tcp_ports: [
    ssh_port,
  ]

  prometheus_scrape_configs: [
    {
      job_name: "node"
      static_configs: [
        {
          targets: ["localhost:9100"]
          labels: internal_vagrant_labels
        }
      ]
    },
  ]
}
