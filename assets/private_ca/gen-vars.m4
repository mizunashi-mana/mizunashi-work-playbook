#!/usr/bin/env bash

set -euo pipefail
[ "${TRACE:-false}" = 'true' ] && set -x

CA_DIR="$(cd "$(dirname "$0")" && pwd)"

cat <<EOS >"$CA_DIR/vars.cue"
package __PACKAGE_NAME__

root_ca_certificate:
"""
$(cat "$CA_DIR/rootCA/cacert.pem")
"""
root_ca_privkey: "__ansible_vault":
"""
$(cat "$CA_DIR/rootCA/private/cakey.pem.vaulted")
"""
EOS
