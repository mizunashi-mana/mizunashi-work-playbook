package elasticsearch_setup

import "mizunashi.work/pkg/cue_types"

elasticsearch_setup_upload_user: "log-upload"
elasticsearch_setup_upload_password: cue_types.#Vaulted
