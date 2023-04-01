package private_mastodon_certificate

import "mizunashi.work/pkg/cue_types"

mastodon_local_domain: string

private_mastodon_certificate_fullchain: string
private_mastodon_certificate_chain: string
private_mastodon_certificate_privkey: cue_types.#Vaulted
