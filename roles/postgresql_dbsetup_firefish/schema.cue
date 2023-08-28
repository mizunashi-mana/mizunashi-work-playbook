package postgresql_dbsetup_firefish

import "mizunashi.work/pkg/cue_types"

firefish_postgres_db: string
firefish_postgres_user: string
firefish_postgres_password: cue_types.#Vaulted
