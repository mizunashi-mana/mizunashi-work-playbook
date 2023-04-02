package prometheus

prometheus_listen_port: uint | *9090

prometheus_scrape_configs: [...#ScrapeConfig]

#ScrapeConfig: {
  job_name: string
  scrape_interval?: string
  scrape_timeout?: string
  metrics_path: string | *"/metrics"
  scheme: string | *"http"
  static_configs: [...#StaticConfig]
  relabel_configs: [...#RelabelConfig]
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
