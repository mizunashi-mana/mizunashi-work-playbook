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

elasticsearch_setup_default_index_policy: {
  policy: {
    phases: {
      hot: {
        min_age?: string
        actions: {}
      }
      warm: {
        min_age: string | *"7d"
        actions: {
          forcemerge: {
            max_num_segments: 1
          }
        }
      }
      delete: {
        min_age: string | *"15d"
        actions: {
          delete: {}
        }
      }
    }
  }
}

elasticsearch_setup_default_index_template: {
  index_patterns: ["fluentd-*"]
  template: {
    settings: {
      number_of_shards: 1
      number_of_replicas: 0
      index: {
        lifecycle: {
          name: "idx_policy_default"
        }
      }
    }
  }
}
