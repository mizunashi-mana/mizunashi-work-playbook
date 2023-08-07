package firefish

import "mizunashi.work/pkg/cue_types"

firefish_endpoint_url: string
firefish_listen_port: uint | *4311

firefish_postgres_host: string
firefish_postgres_port: uint
firefish_postgres_db: string | *"firefish"
firefish_postgres_user: string | *"firefish_user"
firefish_postgres_password: cue_types.#Vaulted

firefish_redis_host: string
firefish_redis_port: uint
firefish_redis_password?: cue_types.#Vaulted
firefish_redis_prefix: string | *"firefish_main"

firefish_cache_redis_host: string
firefish_cache_redis_port: uint
firefish_cache_redis_password?: cue_types.#Vaulted
firefish_cache_redis_prefix: string | *"firefish_cache"

firefish_cluster_limit: uint | *1
firefish_outgoing_address_family: "ipv4" | "ipv6" | *"dual"
