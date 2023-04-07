package postgres_exporter

import "mizunashi.work/pkg/cue_types"

postgres_exporter_listen_port: uint | *9187
postgres_exporter_user_name: "postgres_exporter"
postgres_exporter_user_password: cue_types.#Vaulted
