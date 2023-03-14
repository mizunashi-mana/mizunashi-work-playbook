package mastodon

mastodon_local_domain: string
mastodon_single_user_mode: "true" | "false"

mastodon_db_name: string | *"mastodon_production"
mastodon_workuser_name: string | *"mastodon"
mastodon_workuser_password: string

// Use `rake secret` to generate secrets
mastodon_secret_key_base: string
mastodon_otp_secret: string

// Generate with `rake mastodon:webpush:generate_vapid_key`
mastodon_vapid_private_key: string
mastodon_vapid_public_key: string
