package group_vars_public

import "mizunashi.work/pkg/schemas:group_vars_all"

import "mizunashi.work/pkg/roles/firefish"
import "mizunashi.work/pkg/roles/archivedon"
import "mizunashi.work/pkg/roles/redis_server"
import "mizunashi.work/pkg/roles/redis_exporter"
import "mizunashi.work/pkg/roles/postgresql"
import "mizunashi.work/pkg/roles/postgres_exporter"
import "mizunashi.work/pkg/roles/postgres_backup"
import "mizunashi.work/pkg/roles/nginx_site_firefish_front"
import "mizunashi.work/pkg/roles/nginx_site_archivedon_front"
import "mizunashi.work/pkg/roles/postgresql_dbsetup_firefish"
import "mizunashi.work/pkg/roles/postgresql_dbsetup_postgres_exporter"

group_vars_all
firefish
archivedon
redis_server
redis_exporter
postgresql
postgres_exporter
postgres_backup
nginx_site_firefish_front
nginx_site_archivedon_front
postgresql_dbsetup_firefish
postgresql_dbsetup_postgres_exporter
