package ca_certs

ca_certs_public_bundle_file: "/etc/ssl/certs/ca-certificates.crt"

ca_certs_private_certs_dir: "/etc/ssl/private-certs"
ca_certs_private_bundle_file: "\(ca_certs_private_certs_dir)/ca-certificates.crt"
ca_certs_private_root_ca_cert_file: "\(ca_certs_private_certs_dir)/private-root-cacert.crt"

ca_certs_private_root_ca_cert: string
