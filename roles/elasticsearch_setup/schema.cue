package elasticsearch_setup

import "mizunashi.work/pkg/cue_types"
import "mizunashi.work/pkg/roles/elasticsearch"

elasticsearch

elasticsearch_setup_users: [string]: #ElasticSearchUserEntry

#ElasticSearchUserEntry: {
  password: cue_types.#Vaulted
  roles: [...string]
}

elasticsearch_setup_auth_user: string
elasticsearch_setup_auth_password: cue_types.#Vaulted
