package fluentd_output_elasticsearch

import "mizunashi.work/pkg/cue_types"

fluentd_output_elasticsearch_scheme: "https" | "http"
fluentd_output_elasticsearch_domain: string
fluentd_output_elasticsearch_port: uint
fluentd_output_elasticsearch_ca_file: string

fluentd_output_elasticsearch_user_name: string
fluentd_output_elasticsearch_user_password: cue_types.#Vaulted

fluentd_output_elasticsearch_entries: [string]: {}
