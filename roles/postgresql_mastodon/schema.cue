package postgresql_mastodon

import "mizunashi.work/pkg/cue_types"

mastodon_db_user_name: string
mastodon_db_user_password: cue_types.#Vaulted
