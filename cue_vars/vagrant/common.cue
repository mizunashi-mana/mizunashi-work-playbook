package common

import "mizunashi.work/pkg/cue_types"

import "mizunashi.work/pkg/private_ca_vagrant:ca_vars"
import "mizunashi.work/pkg/cue_vars/vagrant:hosts"
import "mizunashi.work/pkg/cue_vars/vagrant:ids"

import "mizunashi.work/pkg/schemas:group_vars_all"

let Schema = close({
  group_vars_all

  #ssh_port: uint
  #http_port: uint | *80
  #https_port: uint | *443
  #local_proxy_https_port: uint
  #node_exporter_http_port: uint
  #nginx_exporter_http_port: uint
  #fluent_bit_metrics_http_port: uint
  #private_acme_server_https_port: uint | *6100
  #minio_server_https_port: uint | *6210
  #elasticsearch_https_port: uint | *6310

  #private_acme_challenge_hostname: string
  #private_acme_challenge_url: string

  #minio_server_hostname: string
  #minio_server_url: string

  #elasticsearch_hostname: string

  #local_proxy_jobs: [string]: {
    name: string
    password: cue_types.#Vaulted
  }

  #postgres_backup_config: {
    access_key: string
    secret_key: cue_types.#Vaulted
    bucket: string | *"postgres-backup"
  }
})

Schema & {
  #ssh_port: 22
  #http_port: 80
  #https_port: 443
  #local_proxy_https_port: nginx_site_local_proxy_listen_port
  #node_exporter_http_port: node_exporter_listen_port
  #nginx_exporter_http_port: nginx_exporter_listen_port
  #fluent_bit_metrics_http_port: fluent_bit_metrics_listen_port
  #private_acme_server_https_port: 6100
  #minio_server_https_port: 6210
  #elasticsearch_https_port: 6310

  #private_acme_challenge_hostname: "acme.\(ids.#private_domain)"
  #private_acme_challenge_url: "https://\(#private_acme_challenge_hostname):\(#private_acme_server_https_port)/acme/local/directory"

  #minio_server_hostname: "minio.\(ids.#private_domain)"
  #minio_server_url: "https://\(#minio_server_hostname):\(#minio_server_https_port)"

  #elasticsearch_hostname: "elasticsearch.\(ids.#private_domain)"

  #local_proxy_jobs: prometheus: {
    name: "prometheus"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: grafana: {
    name: "grafana"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: node: {
    name: "node"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: nginx: {
    name: "nginx"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: redis: {
    name: "redis"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: postgres: {
    name: "postgres"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: statsd: {
    name: "statsd"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: caddy: {
    name: "caddy"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: minio: {
    name: "minio"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: elasticsearch: {
    name: "elasticsearch"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: fluent_bit: {
    name: "fluent-bit"
    password: ids.#local_proxy_password
  }
  #local_proxy_jobs: mastodon_streaming: {
    name: "mastodon-streaming"
    password: ids.#local_proxy_password
  }

  #postgres_backup_config: {
    access_key: ids.#minio_postgres_backup_access.key_id
    secret_key: ids.#minio_postgres_backup_access.secret_key
    bucket: "postgres-backup"
  }

  ansible_port: #ssh_port
  ansible_user: ids.#workuser_name
  ansible_ssh_private_key_file: "./assets/vagrant_ssh_privkey"

  workuser_setup_username: ids.#workuser_name
  workuser_setup_home_directory: "/home/\(workuser_setup_username)"
  workuser_setup_ssh_authorized_keys: {
    for key in ids.#workuser_ssh_authorized_keys {
      "\(key)": {}
    }
  }

  ca_certs_private_root_ca_certs: "private_root_ca_2023": {
    cert: ca_vars.root_ca_certificate
  }

  systemd_resolved_primary_dns: hosts.#dns_resolver_primary_ipv4
  systemd_resolved_fallback_dns: {
    "\(hosts.#dns_resolver_primary_ipv6)": {}
    hosts.#dns_resolvers_secondary_ipv4
  }

  for _, entry in hosts.#host_entries {
    base_hosts_to_ips: "\(entry.internal_host)": entry.internal_ipv6_address
  }
  base_hosts_to_ips: "\(#private_acme_challenge_hostname)": hosts.#host_entries.internal001.internal_ipv6_address
  base_hosts_to_ips: "\(#minio_server_hostname)": hosts.#host_entries.internal001.internal_ipv6_address
  base_hosts_to_ips: "\(#elasticsearch_hostname)": hosts.#host_entries.internal001.internal_ipv6_address

  nftables_accept_tcp_ports: "\(#ssh_port)": {}
  nftables_accept_ports_with_iif: "internal_local_proxy": {
    iif: hosts.#network_internal_iface
    tcp_ports: [
      #local_proxy_https_port
    ]
  }
  nftables_outbound_logging_filter_entries: "local_network_for_all": {
    oif: "lo"
    ip_cond: {
      all: true
    }
    proto_cond: {
      tcp_sports: [
        #fluent_bit_metrics_http_port,
      ]
    }
  }
  nftables_outbound_logging_filter_entries: "nat_network_for_all": {
    oif: "eth0"
    ip_cond: {
      all: true
    }
    proto_cond: {
      tcp_sports: [
        #ssh_port,
      ]
    }
  }
  nftables_outbound_logging_filter_entries: "open_public_network_for_all": {
    oif: hosts.#network_public_iface
    ip_cond: {
      all: true
    }
    proto_cond: {
      tcp_sports: [
        #ssh_port,
      ]
    }
  }
  nftables_outbound_logging_filter_entries: "dns_public_network_for_all": {
    oif: hosts.#network_public_iface
    ip_cond: {
      ipv4_daddrs: [
        hosts.#dns_resolver_primary_ipv4,
        for resolver, _ in hosts.#dns_resolvers_secondary_ipv4 {
          resolver
        },
      ]
      ipv6_daddrs: [
        hosts.#dns_resolver_primary_ipv6,
      ]
    }
    proto_cond: {
      tcp_dports: [
        53,
      ]
      udp_dports: [
        53
      ]
    }
  }
  nftables_outbound_logging_filter_entries: "internal_network_for_all": {
    oif: hosts.#network_internal_iface
    ip_cond: {
      ipv6_daddrs: [
        ids.#internal_ipv6_subnet,
      ]
    }
    proto_cond: {
      icmp: true
      tcp_sports: [
        #http_port,
        #local_proxy_https_port,
      ]
      tcp_dports: [
        #local_proxy_https_port,
        #private_acme_server_https_port,
        #minio_server_https_port,
        #elasticsearch_https_port,
      ]
    }
  }

  openssh_server_listen_port: #ssh_port

  sudo_mail_address: ids.#notification_email

  apticron_notification_email: ids.#notification_email
  certbot_acme_notification_email: ids.#notification_email

  nginx_resolver: hosts.#dns_resolver_primary_ipv4

  nginx_site_http_redirector_listen_port: #http_port

  nginx_site_local_proxy_listen_port: #local_proxy_https_port
  nginx_site_local_proxy_acme_challenge_url: #private_acme_challenge_url

  node_exporter_listen_port: #node_exporter_http_port
  nginx_site_local_proxy_entries: "\(#local_proxy_jobs.node.name)": {
    upstream_port: #node_exporter_http_port
    auth_password: #local_proxy_jobs.node.password
  }

  nginx_exporter_listen_port: #nginx_exporter_http_port
  nginx_site_local_proxy_entries: "\(#local_proxy_jobs.nginx.name)": {
    upstream_port: #nginx_exporter_http_port
    auth_password: #local_proxy_jobs.nginx.password
  }

  fluent_bit_metrics_listen_port: #fluent_bit_metrics_http_port
  nginx_site_local_proxy_entries: "\(#local_proxy_jobs.fluent_bit.name)": {
    upstream_port: #fluent_bit_metrics_http_port
    auth_password: #local_proxy_jobs.fluent_bit.password
  }

  fluent_bit_input_auth_log_tag: "node.auth"
  fluent_bit_input_sshd_log_tag: "node.sshd"
  fluent_bit_input_sudo_log_tag: "node.sudo"
  fluent_bit_input_kern_log_tag: "node.kernel"
  fluent_bit_input_nftables_filter_log_tag: "nftables.filter"
  fluent_bit_input_nftables_output_log_tag: "nftables.output"
  fluent_bit_input_exim4_mainlog_tag: "exim.mainlog"
  fluent_bit_input_fail2ban_log_tag: "fail2ban.log"
  fluent_bit_input_nginx_log_error_tag: "nginx.error"

  #fluent_bit_input_nginx_log_access_http_redirector_tag: "nginx.access.http_redirector"
  fluent_bit_input_nginx_log_access_entries: "\(#fluent_bit_input_nginx_log_access_http_redirector_tag)": {
    log_file: "/var/log/nginx/access.http_redirector.log"
  }

  fluent_bit_output_elasticsearch_domain: #elasticsearch_hostname
  fluent_bit_output_elasticsearch_port: #elasticsearch_https_port
  fluent_bit_output_elasticsearch_tls: {
    ca_file: group_vars_all.ca_certs_bundle_file_with_private_ca
  }

  fluent_bit_output_elasticsearch_user_name: ids.#elasticsearch_log_upload_user.name
  fluent_bit_output_elasticsearch_user_password: ids.#elasticsearch_log_upload_user.password

  fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_auth_log_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_sshd_log_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_sudo_log_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_kern_log_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_nftables_filter_log_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_nftables_output_log_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_exim4_mainlog_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_fail2ban_log_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_nginx_log_error_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(#fluent_bit_input_nginx_log_access_http_redirector_tag)": {}
}
