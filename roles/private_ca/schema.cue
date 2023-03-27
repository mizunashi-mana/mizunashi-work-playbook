package private_ca

import "mizunashi.work/pkg/cue_types"

private_ca_country_name: string
private_ca_state_or_province_name: string
private_ca_locality_name: string
private_ca_organization_name: string | *"Private"
private_ca_organizational_unit_name: string | *"."

private_ca_root_common_name: string | *"Private Root CA"
private_ca_root_key_password: cue_types.#Vaulted

private_ca_inter_tls_common_name: string | *"Private TLS CA"
private_ca_inter_tls_key_password: cue_types.#Vaulted

private_ca_distribution_url_base: string
private_ca_ocsp_url: string
