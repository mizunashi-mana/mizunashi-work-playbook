package elasticsearch_setup

import "mizunashi.work/pkg/cue_types"

elasticsearch_setup_users: [string]: #ElasticSearchUserEntry

#ElasticSearchUserEntry: {
  password: cue_types.#Vaulted
  roles: [...string]
}
