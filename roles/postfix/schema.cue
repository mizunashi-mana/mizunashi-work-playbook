package postfix

import "mizunashi.work/pkg/cue_types"

postfix_hostname: string

postfix_smtp_listen_port: uint | *25
postfix_submission_listen_port: uint | *587

postfix_relayhost_hostname: string
postfix_relayhost_port: uint
postfix_relayhost_auth_username: string
postfix_relayhost_auth_password: cue_types.#Vaulted

postfix_cert_acme_challenge_url: string
postfix_cert_ca_bundle_path: string

postfix_submission_auth_username: string
postfix_submission_auth_password: cue_types.#Vaulted

postfix_inet_protocols: string | *"all"
