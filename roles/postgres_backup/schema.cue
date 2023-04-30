package postgres_backup

import "mizunashi.work/pkg/cue_types"

postgres_backup_s3_scheme: string
postgres_backup_s3_access_key: string
postgres_backup_s3_secret_key: cue_types.#Vaulted
postgres_backup_s3_hostname: string
postgres_backup_s3_port: uint
postgres_backup_s3_bucket: string
