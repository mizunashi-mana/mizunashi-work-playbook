import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/cue_vars/vagrant_ids"
import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/schemas/group_vars_public"

let ids = vagrant_ids

#Schema: group_vars_public
#Schema: vagrant

#Schema & {
  mastodon_local_domain: ids.#mastodon_hostname

  nginx_site_http_redirector_listen_port: #Schema.#http_port
  nginx_site_mastodon_front_listen_port: #Schema.#https_port

  nftables_accept_tcp_ports: "\(#Schema.#http_port)": {}
  nftables_accept_tcp_ports: "\(#Schema.#https_port)": {}
  nftables_outbound_logging_filter_entries: "local_network_for_public": {
    oif: "lo"
    ip_cond: {
      all: true
    }
    proto_cond: {
      tcp_sports: [
        #Schema.redis_server_listen_port,
      ]
      tcp_dports: [
        #Schema.redis_server_listen_port,
      ]
    }
  }
  nftables_outbound_logging_filter_entries: "open_public_network_for_public": {
    oif: #Schema.network_public_iface
    ip_cond: {
      all: true
    }
    proto_cond: {
      tcp_sports: [
        #Schema.#http_port,
        #Schema.#https_port,
      ]
    }
  }

  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.redis.name)": {
    upstream_port: #Schema.redis_exporter_listen_port
    auth_password: #Schema.#local_proxy_jobs.redis.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.postgres.name)": {
    upstream_port: #Schema.postgres_exporter_listen_port
    auth_password: #Schema.#local_proxy_jobs.postgres.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.statsd.name)": {
    upstream_port: #Schema.statsd_exporter_web_listen_port
    auth_password: #Schema.#local_proxy_jobs.statsd.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.mastodon_streaming.name)": {
    upstream_port: #Schema.mastodon_streaming_listen_port
    auth_password: #Schema.#local_proxy_jobs.mastodon_streaming.password
  }

  nginx_site_mastodon_front_acme_challenge_url: #Schema.#private_acme_challenge_url
  nginx_site_mastodon_front_ca_bundle_path: #Schema.ca_certs_bundle_file_with_private_ca
  nginx_site_mastodon_front_maintenance_mode: false

  #fluent_bit_input_nginx_log_access_mastodon_front_tag: "nginx.access.mastodon_front"
  fluent_bit_input_nginx_log_access_entries: "\(#fluent_bit_input_nginx_log_access_mastodon_front_tag)": {
    log_file: "/var/log/nginx/access.mastodon_front.log"
  }

  fluent_bit_output_elasticsearch_entries: "\(#fluent_bit_input_nginx_log_access_mastodon_front_tag)": {}

  postgresql_max_connections: 20
  postgresql_shared_buffers: "128MB"
  postgresql_effective_cache_size: "200MB"
  postgresql_maintenance_work_mem: "40MB"
  postgresql_checkpoint_completion_target: 0.9
  postgresql_wal_buffers: "5MB"
  postgresql_default_statistics_target: 100
  postgresql_random_page_cost: 1.1
  postgresql_effective_io_concurrency: 100
  postgresql_work_mem: "768kB"
  postgresql_min_wal_size: "1GB"
  postgresql_max_wal_size: "2GB"

  postgres_backup_s3_scheme: "https"
  postgres_backup_s3_access_key: #Schema.#postgres_backup_config.access_key
  postgres_backup_s3_secret_key: #Schema.#postgres_backup_config.secret_key
  postgres_backup_s3_hostname: #Schema.#minio_server_hostname
  postgres_backup_s3_port: #Schema.#minio_server_https_port
  postgres_backup_s3_bucket: #Schema.#postgres_backup_config.bucket

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
