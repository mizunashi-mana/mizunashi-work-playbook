package host_vars

import "mizunashi.work/pkg/cue_types"

import "mizunashi.work/pkg/roles/network:network_host_schema"

ansible_become_password?: cue_types.#Vaulted

network_host_schema
