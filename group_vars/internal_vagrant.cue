import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/cue_vars/vagrant_ids"
import "mizunashi.work/pkg/cue_vars/vagrant_hosts"
import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/schemas/group_vars_internal"

let ca_vars = private_ca_vagrant
let ids = vagrant_ids
let hosts = vagrant_hosts

#Schema: group_vars_internal
#Schema: vagrant

let local_proxy_scrape_configs = {
  prometheus: {
    metrics_path: "/metrics"
    host_entries: hosts.#internal_host_entries
  },
  grafana: {
    metrics_path: "/metrics"
    host_entries: hosts.#internal_host_entries
  },
  node: {
    metrics_path: "/metrics"
    host_entries: hosts.#host_entries
  },
  nginx: {
    metrics_path: "/metrics"
    host_entries: hosts.#host_entries
  },
  redis: {
    metrics_path: "/metrics"
    host_entries: hosts.#public_host_entries
  },
  postgres: {
    metrics_path: "/metrics"
    host_entries: hosts.#public_host_entries
  },
  statsd: {
    metrics_path: "/metrics"
    host_entries: hosts.#public_host_entries
  },
  caddy: {
    metrics_path: "/metrics"
    host_entries: hosts.#internal_host_entries
  },
  minio: {
    metrics_path: "/minio/v2/metrics/cluster"
    host_entries: hosts.#internal_host_entries
  },
  elasticsearch: {
    metrics_path: "/metrics"
    host_entries: hosts.#internal_host_entries
  },
  fluent_bit: {
    metrics_path: "/api/v1/metrics/prometheus"
    host_entries: hosts.#host_entries
  },
  mastodon_streaming: {
    metrics_path: "/metrics"
    host_entries: hosts.#public_host_entries
  },
}

let blackbox_exporter_relabel_configs = [
  #Schema.#hostname_relabel_config,
  {
    source_labels: ["__address__"]
    target_label: "__param_target"
  },
  {
    source_labels: ["__param_target"]
    target_label: "instance"
  },
  {
    target_label: "__address__"
    replacement: "[::1]:\(#Schema.blackbox_exporter_listen_port)"
  },
]

#BlackboxExporterScrapeConfig: #Schema.#ScrapeConfig
#BlackboxExporterScrapeConfig: scheme: "http"
#BlackboxExporterScrapeConfig: metrics_path: "/probe"
#BlackboxExporterScrapeConfig: relabel_configs: blackbox_exporter_relabel_configs

#Schema & {
  nftables_accept_ports_with_iif: "internal_services": {
    iif: #Schema.network_internal_iface
    tcp_ports: [
      #Schema.#private_acme_server_https_port,
      #Schema.#elasticsearch_https_port,
      #Schema.#minio_server_https_port,
    ]
  }
  nftables_outbound_logging_filter_entries: "internal_network_for_internal": {
    oif: #Schema.network_internal_iface
    ip_cond: {
      ipv6_daddrs: [
        ids.#internal_ipv6_subnet,
      ]
    }
    proto_cond: {
      tcp_sports: [
        #Schema.#private_acme_server_https_port,
        #Schema.#elasticsearch_https_port,
        #Schema.#minio_server_https_port,
      ]
      tcp_dports: [
        #Schema.#http_port,
      ]
    }
  }
  nftables_outbound_logging_filter_entries: "public_network_for_internal": {
    oif: #Schema.network_public_iface
    ip_cond: {
      ipv4_daddrs: [
        for _, host_entry in hosts.#public_host_entries {
          host_entry.public_ipv4_address
        }
      ]
      ipv6_daddrs: [
        for _, host_entry in hosts.#public_host_entries {
          host_entry.public_ipv6_address
        }
      ]
    }
    proto_cond: {
      tcp_dports: [
        #Schema.#http_port,
        #Schema.#https_port,
      ]
    }
  }

  caddy_pki_ca_local_name: ids.#private_pki.ca_name
  caddy_pki_ca_local_root_cn: ids.#private_pki.common_name
  caddy_pki_ca_local_root_cert: ca_vars.root_ca_certificate
  caddy_pki_ca_local_root_key: ca_vars.root_ca_privkey

  caddy_site_acme_server_name: #Schema.#private_acme_challenge_hostname
  caddy_site_acme_server_listen_port: #Schema.#private_acme_server_https_port

  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.caddy.name)": {
    upstream_port: #Schema.caddy_metrics_listen_port
    auth_password: #Schema.#local_proxy_jobs.caddy.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.minio.name)": {
    upstream_port: #Schema.minio_server_listen_port
    auth_password: #Schema.#local_proxy_jobs.minio.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.prometheus.name)": {
    upstream_port: #Schema.prometheus_listen_port
    auth_password: #Schema.#local_proxy_jobs.prometheus.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.grafana.name)": {
    upstream_port: #Schema.grafana_listen_port
    auth_password: #Schema.#local_proxy_jobs.grafana.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.elasticsearch.name)": {
    upstream_port: #Schema.elasticsearch_exporter_listen_port
    auth_password: #Schema.#local_proxy_jobs.elasticsearch.password
  }

  minio_server_url: #Schema.#minio_server_url
  minio_root_password: ids.#minio_root_password

  let postgres_backup_policy = "postgres-backup"
  minio_setup_user_entries: "\(#Schema.#postgres_backup_config.access_key)": {
    attach_policy: postgres_backup_policy
    secret_key: #Schema.#postgres_backup_config.secret_key
  }
  minio_setup_bucket_entries: "\(#Schema.#postgres_backup_config.bucket)": {}
  minio_setup_policy_entries: "\(postgres_backup_policy)": {
    statement: [
      {
        action: [
          "s3:GetObject",
          "s3:PutObject",
        ]
        resource: [
          "arn:aws:s3:::\(#Schema.#postgres_backup_config.bucket)/*",
        ]
      }
    ]
  }

  nginx_site_minio_server_listen_port: #Schema.#minio_server_https_port
  nginx_site_minio_server_domain: #Schema.#minio_server_hostname
  nginx_site_minio_server_acme_challenge_url: #Schema.#private_acme_challenge_url
  nginx_site_minio_server_ca_bundle_path: #Schema.ca_certs_bundle_file_with_private_ca

  elasticsearch_exporter_elasticsearch_user_name: ids.#elasticsearch_elasticsearch_exporter_user.name
  elasticsearch_exporter_elasticsearch_user_password: ids.#elasticsearch_elasticsearch_exporter_user.password

  elasticsearch_domain: #Schema.#elasticsearch_hostname
  elasticsearch_setup_users: {
    "\(#Schema.fluent_bit_output_elasticsearch_user_name)": {
      roles: [
        "logstash_upload",
      ]
      password: #Schema.fluent_bit_output_elasticsearch_user_password
    }
    "\(elasticsearch_exporter_elasticsearch_user_name)": {
      roles: [
        "elasticsearch_exporter",
      ]
      password: elasticsearch_exporter_elasticsearch_user_password
    }
    "\(ids.#elasticsearch_grafana_datasource_user.name)": {
      roles: [
        "grafana_datasource"
      ]
      password: ids.#elasticsearch_grafana_datasource_user.password
    }
  }

  nginx_site_elasticsearch_listen_port: #Schema.#elasticsearch_https_port
  nginx_site_elasticsearch_acme_challenge_url: #Schema.#private_acme_challenge_url
  nginx_site_elasticsearch_ca_bundle_path: #Schema.ca_certs_bundle_file_with_private_ca

  #fluent_bit_input_caddy_log_access_default_tag: "caddy.default"
  fluent_bit_input_caddy_log_access_entries: "\(#fluent_bit_input_caddy_log_access_default_tag)": {
    log_file: "/var/log/caddy/default.log"
  }

  fluent_bit_output_elasticsearch_entries: "\(#fluent_bit_input_caddy_log_access_default_tag)": {}

  grafana_admin_password: ids.#grafana_admin_password
  grafana_admin_email: ids.#account_email
  grafana_secret_key: ids.#grafana_secret_key

  grafana_provisioning_datasources: {
    "ds_prometheus": {
      type: "prometheus"
      name: "Prometheus"
      orgId: 1
      url: "http://[::1]:9090"
      is_default: true
      version: 1
      editable: false
    },
    "ds_elasticsearch": {
      type: "elasticsearch"
      name: "ElasticSearch"
      orgId: 1
      url: "http://[::1]:9200"
      version: 1
      editable: false
      basic_auth: {
        user: ids.#elasticsearch_grafana_datasource_user.name
        password: ids.#elasticsearch_grafana_datasource_user.password
      }
    }
  }
  grafana_provisioning_notification_email: ids.#notification_email

  mstdn_rss2bsky_post_feed_url: "https://mstdn.mizunashi.work/@mizunashi_mana.rss"
  mstdn_rss2bsky_post_dry_run: true
  mstdn_rss2bsky_post_atproto_identifier: ids.#mstdn_rss2bsky_post_user.identifier
  mstdn_rss2bsky_post_atproto_password: ids.#mstdn_rss2bsky_post_user.password

  prometheus_scrape_configs: [
    for job_key, entry in local_proxy_scrape_configs {
      {
        job_name: #Schema.#local_proxy_jobs[job_key].name
        metrics_path: entry.metrics_path
        basic_auth: {
          username: #Schema.#local_proxy_jobs[job_key].name
          password: #Schema.#local_proxy_jobs[job_key].password
        }
        tls_config: {
          ca_file: #Schema.ca_certs_bundle_file_with_private_ca
        }
        static_configs: [{
          targets: [
            for _, host_entry in entry.host_entries {
              "\(host_entry.internal_host):\(#Schema.#local_proxy_https_port)"
            }
          ]
        }]
      }
    },
    #BlackboxExporterScrapeConfig & {
      job_name: "blackbox_http_2xx"
      params: {
        module: ["http_2xx"]
      }
      static_configs: [{
        targets: [
        ]
      }]
    },
    #BlackboxExporterScrapeConfig & {
      job_name: "blackbox_http_redirect"
      params: {
        module: ["http_redirect"]
      }
      static_configs: [{
        targets: [
          for _, host_entry in hosts.#host_entries {
            "http://\(host_entry.internal_host):\(#Schema.#http_port)"
          },
          "http://\(ids.#www_hostname)/",
          "https://\(ids.#www_hostname)/",
          "http://\(ids.#root_hostname)/",
          "https://\(ids.#root_hostname)/",
        ]
      }]
    },
    #BlackboxExporterScrapeConfig & {
      job_name: "blackbox_private_http_2xx"
      params: {
        module: ["private_http_2xx"]
      }
      static_configs: [{
        targets: [
          for _, host_entry in hosts.#host_entries {
            "https://\(host_entry.internal_host):\(#Schema.#local_proxy_https_port)/monitor/l7check"
          },
          #Schema.#private_acme_challenge_url,
          "https://\(ids.#mastodon_hostname):\(#Schema.#https_port)/",
        ]
      }]
    },
    #BlackboxExporterScrapeConfig & {
      job_name: "blackbox_private_http_not_authed"
      params: {
        module: ["private_http_not_authed"]
      }
      static_configs: [{
        targets: [
          #Schema.#minio_server_url,
          "https://\(#Schema.#elasticsearch_hostname):\(#Schema.#elasticsearch_https_port)/",
        ]
      }]
    },
    #BlackboxExporterScrapeConfig & {
      job_name: "blackbox_icmp"
      params: {
        module: ["icmp"]
      }
      static_configs: [{
        targets: [
          for _, host_entry in hosts.#host_entries {
            host_entry.internal_host
          },
        ]
      }]
    },
  ]
}
