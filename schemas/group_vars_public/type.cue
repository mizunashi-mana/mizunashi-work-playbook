package group_vars_public

import "mizunashi.work/pkg/schemas/group_vars_all"

import "mizunashi.work/pkg/roles/exim"
import "mizunashi.work/pkg/roles/mastodon"
import "mizunashi.work/pkg/roles/redis_server"
import "mizunashi.work/pkg/roles/redis_exporter"
import "mizunashi.work/pkg/roles/postgresql"
import "mizunashi.work/pkg/roles/postgres_exporter"
import "mizunashi.work/pkg/roles/statsd_exporter"
import "mizunashi.work/pkg/roles/nginx_site_mastodon_front"
import "mizunashi.work/pkg/roles/postgresql_mastodon"
import "mizunashi.work/pkg/roles/postgresql_postgres_exporter"

group_vars_all
exim
mastodon
redis_server
redis_exporter
postgresql
postgres_exporter
statsd_exporter
nginx_site_mastodon_front
postgresql_mastodon
postgresql_postgres_exporter
