package fluent_bit_output_elasticsearch

import "mizunashi.work/pkg/cue_types"

fluent_bit_output_elasticsearch_domain: string
fluent_bit_output_elasticsearch_port: uint
fluent_bit_output_elasticsearch_tls?: {
  ca_file: string
}

fluent_bit_output_elasticsearch_user_name: string
fluent_bit_output_elasticsearch_user_password: cue_types.#Vaulted

fluent_bit_output_elasticsearch_entries: [string]: {}
