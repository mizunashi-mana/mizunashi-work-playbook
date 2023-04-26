package elasticsearch_exporter

import "mizunashi.work/pkg/roles/ca_certs"
import "mizunashi.work/pkg/cue_types"

elasticsearch_exporter_listen_port: uint | *9114

elasticsearch_listen_port: uint
elasticsearch_exporter_elasticsearch_user_name: string
elasticsearch_exporter_elasticsearch_user_password: cue_types.#Vaulted

elasticsearch_exporter_ca_cert_file: ca_certs.ca_certs_bundle_file_with_private_ca
