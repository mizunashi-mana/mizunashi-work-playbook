package postgres_exporter

import "mizunashi.work/pkg/cue_types"

import "mizunashi.work/pkg/roles/postgresql"

postgresql

postgres_exporter_listen_port: uint | *9187
postgres_exporter_user_name: string
postgres_exporter_user_password: cue_types.#Vaulted
