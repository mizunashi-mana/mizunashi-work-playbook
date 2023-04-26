package ca_certs

ca_certs_public_bundle_file: "/etc/ssl/certs/ca-certificates.crt"

ca_certs_private_certs_dir: "/etc/ssl/private-certs"
ca_certs_private_bundle_file: "\(ca_certs_private_certs_dir)/private-ca-certificates.crt"
ca_certs_bundle_file_with_private_ca: "\(ca_certs_private_certs_dir)/ca-certificates.crt"

ca_certs_private_root_ca_certs: [string]: #CACertEntry

#CACertEntry: {
  cert: string
}
