package prometheus

#ScrapeConfig: {
  job_name: string
  scrape_interval?: string
  scrape_timeout?: string
  metrics_path: string | *"/metrics"
  scheme: string | *"http"
  static_configs: [...#StaticConfig]
}

#StaticConfig: {
  targets: [...string]
  labels: [string]: string
}

prometheus_scrape_configs: [...#ScrapeConfig]
