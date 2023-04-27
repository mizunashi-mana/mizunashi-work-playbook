import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/schemas/group_vars_internal"

let ca_vars = private_ca_vagrant

#Schema: group_vars_internal
#Schema: vagrant

let local_proxy_scrape_configs = {
  "prometheus": {
    metrics_path: "/metrics"
    host_entries: #Schema.#internal_host_entries
  },
  "grafana": {
    metrics_path: "/metrics"
    host_entries: #Schema.#internal_host_entries
  },
  "node": {
    metrics_path: "/metrics"
    host_entries: #Schema.#host_entries
  },
  "nginx": {
    metrics_path: "/metrics"
    host_entries: #Schema.#host_entries
  },
  "redis": {
    metrics_path: "/metrics"
    host_entries: #Schema.#public_host_entries
  },
  "postgres": {
    metrics_path: "/metrics"
    host_entries: #Schema.#public_host_entries
  },
  "statsd": {
    metrics_path: "/metrics"
    host_entries: #Schema.#public_host_entries
  },
  "caddy": {
    metrics_path: "/metrics"
    host_entries: #Schema.#internal_host_entries
  },
  "minio": {
    metrics_path: "/minio/v2/metrics/cluster"
    host_entries: #Schema.#internal_host_entries
  },
  "fluentd": {
    metrics_path: "/metrics"
    host_entries: #Schema.#host_entries
  },
  "elasticsearch": {
    metrics_path: "/metrics"
    host_entries: #Schema.#internal_host_entries
  }
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
    replacement: "127.0.0.1:\(#Schema.blackbox_exporter_listen_port)"
  },
]

let grafana_elasticsearch_datasource_user = {
  name: "grafana_datasource"
  password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  62356637313731376334383336616332393936306231343930343163666366613062643330323366
  3234626231666439646234653165393839306439326261370a346332316463623539623639623633
  61656566353831363366653531383530663564633661363361306134346338643761386136316565
  3033656435353263620a356264383762373763313464363235393734346261333666346234653832
  3666
  """
}

#BlackboxExporterScrapeConfig: #Schema.#ScrapeConfig
#BlackboxExporterScrapeConfig: scheme: "http"
#BlackboxExporterScrapeConfig: metrics_path: "/probe"
#BlackboxExporterScrapeConfig: relabel_configs: blackbox_exporter_relabel_configs

#Schema & {
  nftables_accept_tcp_ports: [
    #Schema.#ssh_port,
  ]

  nftables_accept_ports_with_iif: "internal_services": {
    iif: #Schema.network_internal_iface
    tcp_ports: [
      #Schema.#private_acme_server_https_port,
      #Schema.#elasticsearch_https_port,
      #Schema.#minio_server_https_port,
    ]
  }

  caddy_pki_ca_local_name: "mizunashi-work-playbook Local Authority"
  caddy_pki_ca_local_root_cn: "mizunashi-work-playbook - 2023 ECC Root"
  caddy_pki_ca_local_root_cert: ca_vars.root_ca_certificate
  caddy_pki_ca_local_root_key: ca_vars.root_ca_privkey

  caddy_site_acme_server_name: #Schema.#private_acme_challenge_hostname
  caddy_site_acme_server_listen_port: #Schema.#private_acme_server_https_port

  nginx_site_local_proxy_entries: "caddy": {
    upstream_port: #Schema.caddy_metrics_listen_port
    auth_password: #Schema.#local_proxy_password
  }
  nginx_site_local_proxy_entries: "minio": {
    upstream_port: #Schema.minio_server_listen_port
    auth_password: #Schema.#local_proxy_password
  }
  nginx_site_local_proxy_entries: "prometheus": {
    upstream_port: #Schema.prometheus_listen_port
    auth_password: #Schema.#local_proxy_password
  }
  nginx_site_local_proxy_entries: "grafana": {
    upstream_port: #Schema.grafana_listen_port
    auth_password: #Schema.#local_proxy_password
  }
  nginx_site_local_proxy_entries: "elasticsearch": {
    upstream_port: #Schema.elasticsearch_exporter_listen_port
    auth_password: #Schema.#local_proxy_password
  }

  minio_server_url: #Schema.#minio_server_url
  minio_root_password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  62356637313731376334383336616332393936306231343930343163666366613062643330323366
  3234626231666439646234653165393839306439326261370a346332316463623539623639623633
  61656566353831363366653531383530663564633661363361306134346338643761386136316565
  3033656435353263620a356264383762373763313464363235393734346261333666346234653832
  3666
  """
  nginx_site_minio_server_listen_port: #Schema.#minio_server_https_port
  nginx_site_minio_server_domain: #Schema.#minio_server_hostname
  nginx_site_minio_server_acme_challenge_url: #Schema.#private_acme_challenge_url
  nginx_site_minio_server_ca_bundle_path: #Schema.ca_certs_bundle_file_with_private_ca

  elasticsearch_exporter_elasticsearch_user_name: "elasticsearch_exporter"
  elasticsearch_exporter_elasticsearch_user_password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  62356637313731376334383336616332393936306231343930343163666366613062643330323366
  3234626231666439646234653165393839306439326261370a346332316463623539623639623633
  61656566353831363366653531383530663564633661363361306134346338643761386136316565
  3033656435353263620a356264383762373763313464363235393734346261333666346234653832
  3666
  """

  elasticsearch_domain: #Schema.#elasticsearch_hostname
  elasticsearch_setup_users: {
    "\(#Schema.fluentd_output_elasticsearch_user_name)": {
      roles: [
        "logstash_upload",
      ]
      password: #Schema.fluentd_output_elasticsearch_user_password
    }
    "\(elasticsearch_exporter_elasticsearch_user_name)": {
      roles: [
        "elasticsearch_exporter",
      ]
      password: elasticsearch_exporter_elasticsearch_user_password
    }
    "\(grafana_elasticsearch_datasource_user.name)": {
      roles: [
        "grafana_datasource"
      ]
      password: grafana_elasticsearch_datasource_user.password
    }
  }

  nginx_site_elasticsearch_listen_port: #Schema.#elasticsearch_https_port
  nginx_site_elasticsearch_acme_challenge_url: #Schema.#private_acme_challenge_url
  nginx_site_elasticsearch_ca_bundle_path: #Schema.ca_certs_bundle_file_with_private_ca

  grafana_admin_password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  62356637313731376334383336616332393936306231343930343163666366613062643330323366
  3234626231666439646234653165393839306439326261370a346332316463623539623639623633
  61656566353831363366653531383530663564633661363361306134346338643761386136316565
  3033656435353263620a356264383762373763313464363235393734346261333666346234653832
  3666
  """
  grafana_admin_email: #Schema.#account_email
  grafana_secret_key: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  31366134656464326563336233646561313931643962323836643336336563393733353764353338
  3538376138313835363535623431633035613631623439300a386431613764613539316230313335
  63643962313361376532653535326131366635663165646262646262613137613538613932366666
  3230643631393831320a356131306564656134633161353562316165333533343030376531383136
  39613832323838636132303962663638376162616364343630363665323462613434336164306336
  6234396437353461323831646431373561373433373963333665
  """

  grafana_provisioning_datasources: {
    "ds_prometheus": {
      type: "prometheus"
      name: "Prometheus"
      orgId: 1
      url: "http://127.0.0.1:9090"
      is_default: true
      version: 1
      editable: false
    },
    "ds_elasticsearch": {
      type: "elasticsearch"
      name: "ElasticSearch"
      orgId: 1
      url: "http://127.0.0.1:9200"
      version: 1
      editable: false
      basic_auth: {
        user: grafana_elasticsearch_datasource_user.name
        password: grafana_elasticsearch_datasource_user.password
      }
    }
  }

  prometheus_scrape_configs: [
    for job, entry in local_proxy_scrape_configs {
      {
        job_name: job
        metrics_path: entry.metrics_path
        basic_auth: {
          username: job
          password: #Schema.#local_proxy_password
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
          for _, host_entry in #Schema.#host_entries {
            "http://\(host_entry.internal_host):\(#Schema.#http_port)"
          },
          "http://\(#Schema.#www_hostname):\(#Schema.#http_port)/",
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
          for _, host_entry in #Schema.#host_entries {
            "https://\(host_entry.internal_host):\(#Schema.#local_proxy_https_port)/monitor/l7check"
          },
          #Schema.#private_acme_challenge_url,
          "https://\(#Schema.#mastodon_hostname):\(#Schema.#https_port)/",
        ]
      }]
    },
    #BlackboxExporterScrapeConfig & {
      job_name: "blackbox_private_http_redirect"
      params: {
        module: ["private_http_redirect"]
      }
      static_configs: [{
        targets: [
          "https://\(#Schema.#www_hostname):\(#Schema.#https_port)/",
        ]
      }]
    },
  ]
}
