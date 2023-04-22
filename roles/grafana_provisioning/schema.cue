package grafana_provisioning

import "mizunashi.work/pkg/cue_types"

grafana_provisioning_datasources: [string]: #DataSourceEntry

#DataSourceEntry: {
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
