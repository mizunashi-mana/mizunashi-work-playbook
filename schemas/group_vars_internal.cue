package group_vars_internal

import "mizunashi.work/pkg/schemas:group_vars_all"

import "mizunashi.work/pkg/roles/minio"
import "mizunashi.work/pkg/roles/minio_setup"
import "mizunashi.work/pkg/roles/elasticsearch"
import "mizunashi.work/pkg/roles/elasticsearch_setup"
import "mizunashi.work/pkg/roles/elasticsearch_exporter"
import "mizunashi.work/pkg/roles/prometheus"
import "mizunashi.work/pkg/roles/blackbox_exporter"
import "mizunashi.work/pkg/roles/grafana"
import "mizunashi.work/pkg/roles/grafana_provisioning"
import "mizunashi.work/pkg/roles/mstdn_rss2bsky_post"
import "mizunashi.work/pkg/roles/caddy"
import "mizunashi.work/pkg/roles/caddy_site_acme_server"
import "mizunashi.work/pkg/roles/nginx_site_minio_server"
import "mizunashi.work/pkg/roles/nginx_site_elasticsearch"
import "mizunashi.work/pkg/roles/fluent_bit_input_caddy_log"

group_vars_all
minio
minio_setup
elasticsearch
elasticsearch_setup
elasticsearch_exporter
prometheus
blackbox_exporter
grafana
grafana_provisioning
mstdn_rss2bsky_post
caddy
caddy_site_acme_server
nginx_site_minio_server
nginx_site_elasticsearch
fluent_bit_input_caddy_log
