package minio_setup

import "mizunashi.work/pkg/cue_types"

minio_server_listen_port: uint

minio_root_user: string | *"minio_admin"
minio_root_password: cue_types.#Vaulted

minio_setup_user_entries: [string]: #MinIoUserEntry
minio_setup_bucket_entries: [string]: #MinIoBucketEntry

#MinIoUserEntry: {
  secret_key: cue_types.#Vaulted
}

#MinIoBucketEntry: {
  retension_days: uint | *30
}
