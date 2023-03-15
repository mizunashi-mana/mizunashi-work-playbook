package mastodon

mastodon_local_domain: string
mastodon_single_user_mode: "true" | "false"

mastodon_db_name: string | *"mastodon_production"
mastodon_db_user_name: string | *"mastodon"
mastodon_db_user_password: string

// Use `rake secret` to generate secrets
mastodon_secret_key_base: string
mastodon_otp_secret: string

// Generate with `rake mastodon:webpush:generate_vapid_key`
mastodon_vapid_private_key: string
mastodon_vapid_public_key: string

mastodon_streaming_listen_port: uint | *4112
mastodon_web_listen_port: uint | *4113
