package redis_server

import "mizunashi.work/pkg/cue_types"

redis_server_listen_port: uint | *6379
redis_server_auth_username: "default"
redis_server_auth_password: cue_types.#Vaulted
