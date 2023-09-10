package ap_outbox2bsky_post

import "mizunashi.work/pkg/cue_types"

ap_outbox2bsky_post_outbox_url: string
ap_outbox2bsky_post_atproto_identifier: string
ap_outbox2bsky_post_atproto_password: cue_types.#Vaulted

ap_outbox2bsky_post_dry_run: bool | *false
