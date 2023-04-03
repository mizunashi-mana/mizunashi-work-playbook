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

prometheus_client_certificate_cert: string
prometheus_client_certificate_privkey: cue_types.#Vaulted

#ScrapeConfig: {
  job_name: string
  scrape_interval?: string
  scrape_timeout?: string
  metrics_path: string | *"/metrics"
  scheme: string | *"https"
  params: [string]: string
  enable_tls_client_verification: bool | *false
  static_configs: [...#StaticConfig]
  relabel_configs: [...#RelabelConfig] | *[#hostname_relabel_config]
}

#StaticConfig: {
  targets: [...string]
  labels: [string]: string
}

#RelabelConfig: {
  source_labels: [...string]
  target_label: string
  regex: string
  replacement: string
}
