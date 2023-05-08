package grafana_provisioning

import "mizunashi.work/pkg/cue_types"

grafana_provisioning_datasources: [string]: #DataSourceEntry
grafana_provisioning_notification_email: string

grafana_provisioning_datasources: "ds_prometheus": {
  name: "Prometheus"
  type: "prometheus"
  orgId: 1
  url: string
  is_default: true
  version: 1
  editable: false
  basic_auth?: {
    user: string
    password: cue_types.#Vaulted
  }
  prometheus_type: "Prometheus"
  prometheus_version: "2.24.0"
}

grafana_provisioning_datasources: "ds_elasticsearch": {
  name: "ElasticSearch"
  type: "elasticsearch"
  orgId: 1
  url: string
  is_default: false
  version: 1
  editable: false
  basic_auth?: {
    user: string
    password: cue_types.#Vaulted
  }
  es_version: "8.7.0"
  time_field: "@timestamp"
  max_concurrent_shard_requests: 5
}

#DataSourceEntry: {
  name: string
  orgId: uint | *1
  url: string
  is_default: bool | *false
  version: uint
  editable: bool | *false
  basic_auth?: {
    user: string
    password: cue_types.#Vaulted
  }
} & ({
  type: "prometheus"
  prometheus_type: "Prometheus"
  prometheus_version: "2.24.0"
} | {
  type: "elasticsearch"
  es_version: "8.7.0"
  time_field: string | *"@timestamp"
  max_concurrent_shard_requests: uint | *5
})
