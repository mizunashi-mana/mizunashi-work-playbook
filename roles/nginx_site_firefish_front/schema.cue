package nginx_site_firefish_front

import "mizunashi.work/pkg/roles/firefish"

firefish

nginx_site_firefish_front_listen_port: uint
nginx_site_firefish_front_domain: string

nginx_site_firefish_front_acme_challenge_url: string
nginx_site_firefish_front_ca_bundle_path: string

nginx_site_firefish_front_maintenance_mode: bool