package grafana_provisioning

grafana_provisioning_datasources: [...#DataSourceEntry] | *[#PrometheusDataSourceEntry]

#DataSourceEntry: {
  name: string
  type: "prometheus"
  orgId: uint | *1
  url: string
  is_default: bool | *false
  version: uint
  editable: bool
}

#PrometheusDataSourceEntry: {
  name: "Prometheus"
  type: "prometheus"
  orgId: 1
  url: "http://127.0.0.1:9090"
  is_default: true
  version: 1
  editable: false
}
