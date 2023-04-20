package elasticsearch_exporter

import "mizunashi.work/pkg/roles/ca_certs"

elasticsearch_exporter_listen_port: uint | *9114
elasticsearch_exporter_ca_cert_file: ca_certs.ca_certs_private_root_ca_cert_file
