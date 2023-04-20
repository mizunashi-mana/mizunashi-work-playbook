package elasticsearch

elasticsearch_listen_port: 9200

elasticsearch_roles: [string]: #RoleEntry

#RoleEntry: {
  cluster: [...string]
  indices: [...#RoleIndexEntry]
}

#RoleIndexEntry: {
  names: [...string]
  privileges: [...string]
}
