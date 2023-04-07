import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/schemas/group_vars_internal"

#Schema: group_vars_internal
#Schema: vagrant

let ssh_port = vagrant.#ssh_port
let dns_port = #Schema.dnsmasq_listen_port
let acme_server_https_port = vagrant.#acme_server_https_port

let acme_challenge_hostname = vagrant.#acme_challenge_hostname

#Schema & {
  nftables_accept_tcp_ports: [
    ssh_port,
  ]

  nftables_accept_ports_with_iif: "internal_services": {
    iif: vagrant.#internal_iface
    tcp_ports: [
      dns_port,
      acme_server_https_port,
    ]
    udp_ports: [
      dns_port,
    ]
  }

  dnsmasq_hosts_entries: [
    for _, entry in vagrant.#host_entries {
      {
        ip: entry.internal_ip
        domain: entry.internal_host
      }
    }
    {
      ip: vagrant.#internal_host_entries.internal001.internal_ip
      domain: vagrant.#acme_challenge_hostname
    }
  ]

  caddy_pki_ca_local_name: "mizunashi-work-playbook Local Authority"
  caddy_pki_ca_local_root_cn: "mizunashi-work-playbook - 2023 ECC Root"
  caddy_pki_ca_local_root_cert: private_ca_vagrant.root_ca_certificate
  caddy_pki_ca_local_root_key: private_ca_vagrant.root_ca_privkey

  caddy_site_acme_server_name: acme_challenge_hostname
  caddy_site_acme_server_listen_port: acme_server_https_port

  nginx_site_local_proxy_entries: "caddy": {
    upstream_port: #Schema.caddy_metrics_listen_port
    auth_password: vagrant.#local_proxy_password
  }
  nginx_site_local_proxy_entries: "prometheus": {
    upstream_port: #Schema.prometheus_listen_port
    auth_password: vagrant.#local_proxy_password
  }
  nginx_site_local_proxy_entries: "grafana": {
    upstream_port: #Schema.grafana_listen_port
    auth_password: vagrant.#local_proxy_password
  }

  prometheus_scrape_configs: [
    {
      job_name: "prometheus"
      use_private_ca: true
      basic_auth: {
        username: "prometheus"
        password: vagrant.#local_proxy_password
      }
      static_configs: [{
        targets: [
          for _, entry in vagrant.#internal_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "grafana"
      use_private_ca: true
      basic_auth: {
        username: "grafana"
        password: vagrant.#local_proxy_password
      }
      static_configs: [{
        targets: [
          for _, entry in vagrant.#internal_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "node"
      use_private_ca: true
      basic_auth: {
        username: "node"
        password: vagrant.#local_proxy_password
      }
      static_configs: [{
        targets: [
          for _, entry in vagrant.#host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "nginx"
      use_private_ca: true
      basic_auth: {
        username: "nginx"
        password: vagrant.#local_proxy_password
      }
      static_configs: [{
        targets: [
          for _, entry in vagrant.#host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "redis"
      use_private_ca: true
      basic_auth: {
        username: "redis"
        password: vagrant.#local_proxy_password
      }
      static_configs: [{
        targets: [
          for _, entry in vagrant.#public_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "postgres"
      use_private_ca: true
      basic_auth: {
        username: "postgres"
        password: vagrant.#local_proxy_password
      }
      static_configs: [{
        targets: [
          for _, entry in vagrant.#public_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "statsd"
      use_private_ca: true
      basic_auth: {
        username: "statsd"
        password: vagrant.#local_proxy_password
      }
      static_configs: [{
        targets: [
          for _, entry in vagrant.#public_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "caddy"
      use_private_ca: true
      basic_auth: {
        username: "caddy"
        password: vagrant.#local_proxy_password
      }
      static_configs: [{
        targets: [
          for _, entry in vagrant.#internal_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
  ]
}
