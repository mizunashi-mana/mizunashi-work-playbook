package elasticsearch

elasticsearch_listen_port: uint | *9200
elasticsearch_domain: string

elasticsearch_roles: [string]: #RoleEntry

#RoleEntry: {
  cluster: [...string]
  indices: [...#RoleIndexEntry]
}

#RoleIndexEntry: {
  names: [...string]
  privileges: [...string]
}