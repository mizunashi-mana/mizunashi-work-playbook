package prometheus

import "mizunashi.work/pkg/cue_types"

#hostname_relabel_config: #RelabelConfig
#hostname_relabel_config: {
  source_labels: ["__address__"]
  regex: #"([^:]+):(\d+)"#
  target_label: "hostname"
  replacement: #"${1}"#
}

prometheus_listen_port: uint | *9090

prometheus_scrape_configs: [...#ScrapeConfig]

#ScrapeConfig: {
  job_name: string
  scrape_interval?: string
  scrape_timeout?: string
  metrics_path: string | *"/metrics"
  scheme: string | *"https"
  params: [string]: [...string]
  basic_auth?: #BasicAuth
  tls_config?: {
    ca_file?: string
  }
  static_configs: [...#StaticConfig]
  relabel_configs: [...#RelabelConfig] | *[#hostname_relabel_config]
}

#BasicAuth: {
  username: string
  password: cue_types.#Vaulted
}

#StaticConfig: {
  targets: [...string]
  labels: [string]: string
}

#RelabelConfig: {
  source_labels: [...string]
  target_label: string
  regex?: string
  replacement?: string
}
