package openssl_ocsp_responder

import "mizunashi.work/pkg/cue_types"

#OcspResponderEntry: {
  listen_port: uint

  ca_cert: string
  ca_privkey: cue_types.#Vaulted
  ca_database_content: string
}

openssl_ocsp_responder_entries: [string]: #OcspResponderEntry
