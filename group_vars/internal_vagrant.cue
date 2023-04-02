import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/vagrant_private_ca"

import "mizunashi.work/pkg/roles/prometheus"

#Schema: vagrant
#Schema: prometheus

let ssh_port = vagrant.#ssh_port

let prometheus_phase = "vagrant"
let prometheus_group_internal = "internal"

let internal_vagrant_labels = {
  phase: prometheus_phase
  group: prometheus_group_internal
}

let hostname_relabel_config = {
  source_labels: ["__address__"]
  regex: #"([^:]+):(\d+)"#
  target_label: "hostname"
  replacement: #"${1}"#
}

#Schema & {
  nftables_accept_tcp_ports: [
    ssh_port,
  ]

  prometheus_scrape_configs: {
    "node.\(vagrant.#internal_host_info.hostname)": {
      job_name: "node"
      static_configs: [
        {
          targets: ["\(vagrant.#internal_host_info.hostname):9100"]
          labels: internal_vagrant_labels
        }
      ]
      relabel_configs: [
        hostname_relabel_config
      ]
    }
  }
}
