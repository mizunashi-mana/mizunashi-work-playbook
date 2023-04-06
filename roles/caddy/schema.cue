package caddy

import "mizunashi.work/pkg/cue_types"

caddy_pki_ca_local_name: string
caddy_pki_ca_local_root_cn: string
caddy_pki_ca_local_root_cert: string
caddy_pki_ca_local_root_key: cue_types.#Vaulted

caddy_metrics_listen_port: uint | *2018
