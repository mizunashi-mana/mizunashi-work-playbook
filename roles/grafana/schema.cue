package grafana

import "mizunashi.work/pkg/cue_types"

grafana_listen_port: uint | *9099

grafana_admin_username: string | *"admin"
grafana_admin_password: cue_types.#Vaulted
grafana_admin_email: string
grafana_secret_key: cue_types.#Vaulted
