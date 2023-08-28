import "mizunashi.work/pkg/cue_vars/vagrant:common"
import "mizunashi.work/pkg/cue_vars/vagrant:ids"
import "mizunashi.work/pkg/cue_vars/vagrant:hosts"
import "mizunashi.work/pkg/cue_vars/vagrant:pg_tune"
import "mizunashi.work/pkg/private_ca_vagrant:ca_vars"

import "mizunashi.work/pkg/schemas:group_vars_public"

let Schema = {
  group_vars_public
  common
}

Schema & {
  nginx_site_http_redirector_listen_port: Schema.#http_port

  nginx_site_mastodon_front_listen_port: Schema.#https_port
  mastodon_local_domain: ids.#mastodon_hostname

  nginx_site_firefish_front_listen_port: Schema.#https_port
  nginx_site_firefish_front_domain: ids.#firefish_hostname
  firefish_endpoint_url: "https://\(ids.#firefish_hostname)"

  nginx_site_archivedon_front_listen_port: Schema.#https_port
  nginx_site_archivedon_front_main_domain: "\(ids.#archivedon_main_hostname)"

  nftables_accept_tcp_ports: "\(Schema.#http_port)": {}
  nftables_accept_tcp_ports: "\(Schema.#https_port)": {}
  nftables_outbound_logging_filter_entries: "local_network_for_public": {
    oif: "lo"
    ip_cond: {
      all: true
    }
    proto_cond: {
      tcp_sports: [
        Schema.redis_server_listen_port,
      ]
      tcp_dports: [
        Schema.redis_server_listen_port,
      ]
    }
  }
  nftables_outbound_logging_filter_entries: "open_public_network_for_public": {
    oif: hosts.#network_public_iface
    ip_cond: {
      all: true
    }
    proto_cond: {
      tcp_sports: [
        Schema.#http_port,
        Schema.#https_port,
      ]
    }
  }

  nginx_site_local_proxy_entries: "\(Schema.#local_proxy_jobs.redis.name)": {
    upstream_port: Schema.redis_exporter_listen_port
    auth_password: Schema.#local_proxy_jobs.redis.password
  }
  nginx_site_local_proxy_entries: "\(Schema.#local_proxy_jobs.postgres.name)": {
    upstream_port: Schema.postgres_exporter_listen_port
    auth_password: Schema.#local_proxy_jobs.postgres.password
  }
  nginx_site_local_proxy_entries: "\(Schema.#local_proxy_jobs.statsd.name)": {
    upstream_port: Schema.statsd_exporter_web_listen_port
    auth_password: Schema.#local_proxy_jobs.statsd.password
  }
  nginx_site_local_proxy_entries: "\(Schema.#local_proxy_jobs.mastodon_streaming.name)": {
    upstream_port: Schema.mastodon_streaming_listen_port
    auth_password: Schema.#local_proxy_jobs.mastodon_streaming.password
  }

  nginx_site_firefish_front_acme_challenge_url: Schema.#private_acme_challenge_url
  nginx_site_firefish_front_ca_bundle_path: Schema.ca_certs_bundle_file_with_private_ca
  nginx_site_firefish_front_maintenance_mode: false

  #fluent_bit_input_nginx_log_access_firefish_front_tag: "nginx.access.firefish_front"
  fluent_bit_input_nginx_log_access_entries: "\(#fluent_bit_input_nginx_log_access_firefish_front_tag)": {
    log_file: "/var/log/nginx/access.firefish_front.log"
  }

  fluent_bit_output_elasticsearch_entries: "\(#fluent_bit_input_nginx_log_access_firefish_front_tag)": {}

  nginx_site_mastodon_front_acme_challenge_url: Schema.#private_acme_challenge_url
  nginx_site_mastodon_front_ca_bundle_path: Schema.ca_certs_bundle_file_with_private_ca
  nginx_site_mastodon_front_maintenance_mode: false

  #fluent_bit_input_nginx_log_access_mastodon_front_tag: "nginx.access.mastodon_front"
  fluent_bit_input_nginx_log_access_entries: "\(#fluent_bit_input_nginx_log_access_mastodon_front_tag)": {
    log_file: "/var/log/nginx/access.mastodon_front.log"
  }

  nginx_site_archivedon_front_acme_challenge_url: Schema.#private_acme_challenge_url
  nginx_site_archivedon_front_ca_bundle_path: Schema.ca_certs_bundle_file_with_private_ca

  #fluent_bit_input_nginx_log_access_archivedon_front_tag: "nginx.access.archivedon_front"
  fluent_bit_input_nginx_log_access_entries: "\(#fluent_bit_input_nginx_log_access_archivedon_front_tag)": {
    log_file: "/var/log/nginx/access.archivedon_front.log"
  }

  fluent_bit_output_elasticsearch_entries: "\(#fluent_bit_input_nginx_log_access_mastodon_front_tag)": {}

  postgresql_max_connections: pg_tune.max_connections
  postgresql_shared_buffers: pg_tune.shared_buffers
  postgresql_effective_cache_size: pg_tune.effective_cache_size
  postgresql_maintenance_work_mem: pg_tune.maintenance_work_mem
  postgresql_checkpoint_completion_target: pg_tune.checkpoint_completion_target
  postgresql_wal_buffers: pg_tune.wal_buffers
  postgresql_default_statistics_target: pg_tune.default_statistics_target
  postgresql_random_page_cost: pg_tune.random_page_cost
  postgresql_effective_io_concurrency: pg_tune.effective_io_concurrency
  postgresql_work_mem: pg_tune.work_mem
  postgresql_min_wal_size: pg_tune.min_wal_size
  postgresql_max_wal_size: pg_tune.max_wal_size

  postgres_backup_s3_scheme: "https"
  postgres_backup_s3_access_key: Schema.#postgres_backup_config.access_key
  postgres_backup_s3_secret_key: Schema.#postgres_backup_config.secret_key
  postgres_backup_s3_hostname: Schema.#minio_server_hostname
  postgres_backup_s3_port: Schema.#minio_server_https_port
  postgres_backup_s3_bucket: Schema.#postgres_backup_config.bucket

  firefish_postgres_host: "localhost"
  firefish_postgres_port: Schema.postgresql_listen_port
  firefish_postgres_user: ids.#postgres_firefish_db_user.name
  firefish_postgres_password: ids.#postgres_firefish_db_user.password

  firefish_redis_host: "localhost"
  firefish_redis_port: Schema.redis_server_listen_port
  firefish_redis_password: ids.#redis_server_auth_password

  firefish_cache_redis_host: "localhost"
  firefish_cache_redis_port: Schema.redis_server_listen_port
  firefish_cache_redis_password: ids.#redis_server_auth_password

  mastodon_single_user_mode: "true"

  mastodon_otp_secret: ids.#mastodon_otp_secret
  mastodon_secret_key_base: ids.#mastodon_secret_key_base
  mastodon_vapid_private_key: ids.#mastodon_vapid_secret.private_key
  mastodon_vapid_public_key: ids.#mastodon_vapid_secret.public_key

  mastodon_db_user_name: ids.#postgres_mastodon_db_user.name
  mastodon_db_user_password: ids.#postgres_mastodon_db_user.password

  postgres_exporter_user_name: ids.#postgres_postgres_exporter_user.name
  postgres_exporter_user_password: ids.#postgres_postgres_exporter_user.password

  redis_server_auth_password: ids.#redis_server_auth_password
}
