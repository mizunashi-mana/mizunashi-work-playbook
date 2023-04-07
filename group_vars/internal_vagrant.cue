import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/schemas/group_vars_internal"

let ca_vars = private_ca_vagrant

#Schema: group_vars_internal
#Schema: vagrant

let ssh_port = #Schema.#ssh_port
let dns_port = #Schema.dnsmasq_listen_port
let acme_server_https_port = #Schema.#acme_server_https_port

let acme_challenge_hostname = #Schema.#acme_challenge_hostname

let local_proxy_scrape_configs = {
  "prometheus": {
    host_entries: #Schema.#internal_host_entries
  },
  "grafana": {
    host_entries: #Schema.#internal_host_entries
  },
  "node": {
    host_entries: #Schema.#host_entries
  },
  "nginx": {
    host_entries: #Schema.#host_entries
  },
  "redis": {
    host_entries: #Schema.#public_host_entries
  },
  "postgres": {
    host_entries: #Schema.#public_host_entries
  },
  "statsd": {
    host_entries: #Schema.#public_host_entries
  },
  "caddy": {
    host_entries: #Schema.#internal_host_entries
  },
}

#Schema & {
  nftables_accept_tcp_ports: [
    ssh_port,
  ]

  nftables_accept_ports_with_iif: "internal_services": {
    iif: #Schema.network_internal_iface
    tcp_ports: [
      dns_port,
      acme_server_https_port,
    ]
    udp_ports: [
      dns_port,
    ]
  }

  dnsmasq_hosts_entries: [
    for _, entry in #Schema.#host_entries {
      {
        ip: entry.internal_ip
        domain: entry.internal_host
      }
    }
    {
      ip: #Schema.#host_entries.internal001.internal_ip
      domain: #Schema.#acme_challenge_hostname
    }
  ]

  caddy_pki_ca_local_name: "mizunashi-work-playbook Local Authority"
  caddy_pki_ca_local_root_cn: "mizunashi-work-playbook - 2023 ECC Root"
  caddy_pki_ca_local_root_cert: ca_vars.root_ca_certificate
  caddy_pki_ca_local_root_key: ca_vars.root_ca_privkey

  caddy_site_acme_server_name: acme_challenge_hostname
  caddy_site_acme_server_listen_port: acme_server_https_port

  nginx_site_local_proxy_entries: "caddy": {
    upstream_port: #Schema.caddy_metrics_listen_port
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

  prometheus_scrape_configs: [
    for job, entry in local_proxy_scrape_configs {
      {
        job_name: job
        use_private_ca: true
        basic_auth: {
          username: job
          password: #Schema.#local_proxy_password
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
  ]
}
