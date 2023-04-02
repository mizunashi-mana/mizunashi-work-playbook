package prometheus

prometheus_scrape_configs: [string]: #ScrapeConfig

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
  labels: {
    [string]: string
  }
}

#RelabelConfig: {
  source_labels: [...string]
  target_label: string
  regex: string
  replacement: string
}
