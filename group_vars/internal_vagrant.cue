import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/vagrant_private_ca"

import "mizunashi.work/pkg/roles/dnsmasq"
import "mizunashi.work/pkg/roles/prometheus"
import "mizunashi.work/pkg/roles/grafana"

#Schema: vagrant
#Schema: dnsmasq
#Schema: prometheus
#Schema: grafana

let ssh_port = vagrant.#ssh_port

let prometheus_phase = "vagrant"
let prometheus_group_internal = "internal"

let internal_labels = {
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

  dnsmasq_hosts_entries: {
    for _, entry in vagrant.#hosts_entries {
      "\(entry.ip)": {
        primary_host: entry.host
        additional_hosts: [
          entry.exposed_host,
          "*.\(entry.exposed_host)",
        ]
      }
    }
  }

  prometheus_scrape_configs: [
    {
      job_name: "prometheus"
      static_configs: [
        {
          targets: ["localhost:\(#Schema.prometheus_listen_port)"]
          labels: internal_labels
        }
      ]
      relabel_configs: [hostname_relabel_config]
    },
    {
      job_name: "grafana"
      static_configs: [
        {
          targets: ["localhost:\(#Schema.grafana_listen_port)"]
          labels: internal_labels
        }
      ]
      relabel_configs: [hostname_relabel_config]
    },
    {
      job_name: "node"
      static_configs: [
        {
          targets: ["localhost:\(#Schema.node_exporter_listen_port)"]
          labels: internal_labels
        }
      ]
      relabel_configs: [hostname_relabel_config]
    },
  ]
}
