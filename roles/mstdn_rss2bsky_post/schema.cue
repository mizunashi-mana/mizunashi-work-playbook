package mstdn_rss2bsky_post

import "mizunashi.work/pkg/cue_types"

mstdn_rss2bsky_post_feed_url: string
mstdn_rss2bsky_post_atproto_identifier: string
mstdn_rss2bsky_post_atproto_password: cue_types.#Vaulted

mstdn_rss2bsky_post_dry_run: bool | *false
