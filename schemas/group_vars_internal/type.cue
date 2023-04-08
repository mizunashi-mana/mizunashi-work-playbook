package group_vars_internal

import "mizunashi.work/pkg/schemas/group_vars_all"

import "mizunashi.work/pkg/roles/dnsmasq"
import "mizunashi.work/pkg/roles/postfix"
import "mizunashi.work/pkg/roles/prometheus"
import "mizunashi.work/pkg/roles/grafana"
import "mizunashi.work/pkg/roles/caddy"
import "mizunashi.work/pkg/roles/caddy_site_acme_server"

group_vars_all
dnsmasq
postfix
prometheus
grafana
caddy
caddy_site_acme_server
