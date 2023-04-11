package minio_setup

import "mizunashi.work/pkg/cue_types"

minio_server_listen_port: uint

minio_root_user: string | *"minio_admin"
minio_root_password: cue_types.#Vaulted

minio_user_entries: [string]: #UserEntry

#UserEntry: {
  access_key: string
  secret_key: cue_types.#Vaulted
  target_bucket: string
  retension_days: uint | *30
}
