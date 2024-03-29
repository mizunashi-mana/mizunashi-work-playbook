package elasticsearch

elasticsearch_listen_port: uint | *9200
elasticsearch_domain: string

elasticsearch_heapsize: string

elasticsearch_roles: [string]: #RoleEntry
elasticsearch_roles: es_manager: {
  cluster: [
    "manage_index_templates",
    "monitor",
    "manage_ilm",
  ]
  indices: [
    {
      names: [ "*" ]
      privileges: [
        "read",
        "view_index_metadata",
        "write",
        "manage",
        "manage_ilm",
      ]
    }
  ]
}
elasticsearch_roles: logstash_upload: {
  cluster: [
    "manage_index_templates",
    "monitor",
    "manage_ilm",
  ]
  indices: [
    {
      names: [ "*" ]
      privileges: [
        "write",
        "create",
        "delete",
        "create_index",
        "manage",
        "manage_ilm",
      ]
    }
  ]
}
elasticsearch_roles: elasticsearch_exporter: {
  cluster: [
    "monitor",
    "monitor_snapshot",
    "read_slm",
  ]
  indices: [
    {
      names: [ "*" ]
      privileges: [
        "monitor",
      ]
    }
  ]
}
elasticsearch_roles: grafana_datasource: {
  cluster: [
    "monitor",
  ]
  indices: [
    {
      names: [ "*" ]
      privileges: [
        "monitor",
        "read",
        "view_index_metadata",
      ]
    }
  ]
}

#RoleEntry: {
  cluster: [...string]
  indices: [...#RoleIndexEntry]
}

#RoleIndexEntry: {
  names: [...string]
  privileges: [...string]
}
