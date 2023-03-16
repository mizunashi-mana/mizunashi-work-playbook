package private_ca

import "mizunashi.work/pkg/cuetypes"

private_ca_root_key_password: cuetypes.#AnsibleVault

private_ca_root_country_name: string
private_ca_root_state_or_province_name: string
private_ca_root_locality_name: string
private_ca_root_organization_name: string | *"CA"
private_ca_root_organizational_unit_name: string | *"."
private_ca_root_common_name: string | *"RCA"
