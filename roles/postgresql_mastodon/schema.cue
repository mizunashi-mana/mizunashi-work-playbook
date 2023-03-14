package postgresql_mastodon

postgresql_mastodon_db_name: string | *"mastodon_production"
postgresql_mastodon_workuser_name: string | *"mastodon"

// TODO: support ansible vault
postgresql_mastodon_workuser_password: string
