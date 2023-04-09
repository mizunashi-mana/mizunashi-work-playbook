package exim

import "mizunashi.work/pkg/cue_types"

exim_smarthost_hostname: string
exim_smarthost_port: uint
exim_smarthost_auth_username: string
exim_smarthost_auth_password: cue_types.#Vaulted

exim_ca_certificates: string
