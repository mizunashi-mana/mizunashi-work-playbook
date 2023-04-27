package minio

import "mizunashi.work/pkg/cue_types"

minio_server_listen_port: uint | *6200
minio_console_listen_port: uint | *6201

minio_root_user: string | *"minio_admin"
minio_root_password: cue_types.#Vaulted

minio_server_url: string
