package group_vars_internal

import "mizunashi.work/pkg/schemas/group_vars_all"

import "mizunashi.work/pkg/roles/dnsmasq"
import "mizunashi.work/pkg/roles/minio"
import "mizunashi.work/pkg/roles/minio_setup"
import "mizunashi.work/pkg/roles/elasticsearch"
import "mizunashi.work/pkg/roles/prometheus"
import "mizunashi.work/pkg/roles/blackbox_exporter"
import "mizunashi.work/pkg/roles/grafana"
import "mizunashi.work/pkg/roles/grafana_provisioning"
import "mizunashi.work/pkg/roles/caddy"
import "mizunashi.work/pkg/roles/caddy_site_acme_server"
import "mizunashi.work/pkg/roles/nginx_site_minio_server"

group_vars_all
dnsmasq
minio
minio_setup
elasticsearch
prometheus
blackbox_exporter
grafana
grafana_provisioning
caddy
caddy_site_acme_server
nginx_site_minio_server
