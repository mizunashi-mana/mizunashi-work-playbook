package postgresql_mastodon

postgresql_mastodon_db_name: string | *"mastodon_production"
postgresql_mastodon_workuser_name: string | *"mastodon"
postgresql_mastodon_adminuser_name: string | *"mastodon_admin"

// TODO: support ansible vault
postgresql_mastodon_workuser_password: string
postgresql_mastodon_adminuser_password: string
