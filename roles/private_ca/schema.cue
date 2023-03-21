package private_ca

import "mizunashi.work/pkg/cue_types"

private_ca_country_name: string
private_ca_state_or_province_name: string
private_ca_locality_name: string
private_ca_organization_name: string | *"Private"
private_ca_organizational_unit_name: string | *"."

private_ca_root_common_name: string | *"RCA"
private_ca_root_key_password: cue_types.#Vaulted

private_ca_inter_server_common_name: string | *"InterServerCA"
private_ca_inter_server_key_password: cue_types.#Vaulted

private_ca_inter_client_common_name: string | *"InterClientCA"
private_ca_inter_client_key_password: cue_types.#Vaulted
