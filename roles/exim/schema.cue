package exim

import "mizunashi.work/pkg/cue_types"

exim_smarthost?: {
  hostname: string
  port: uint
  auth_userid: string
  auth_password: cue_types.#Vaulted
}

exim_listen_port: uint | *25
