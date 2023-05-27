package mastodon

import "mizunashi.work/pkg/cue_types"

import "mizunashi.work/pkg/roles/redis_server"

redis_server

mastodon_local_domain: string
mastodon_single_user_mode: "true" | "false"

mastodon_db_name: string | *"mastodon_production"
mastodon_db_user_name: string
mastodon_db_user_password: cue_types.#Vaulted

// Use `rake secret` to generate secrets
mastodon_secret_key_base: cue_types.#Vaulted
mastodon_otp_secret: cue_types.#Vaulted

// Generate with `rake mastodon:webpush:generate_vapid_key`
mastodon_vapid_private_key: cue_types.#Vaulted
mastodon_vapid_public_key: string

mastodon_streaming_listen_port: uint | *4112
mastodon_web_listen_port: uint | *4113
