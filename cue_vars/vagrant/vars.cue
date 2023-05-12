package vagrant

import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/schemas/group_vars_all"

let ca_vars = private_ca_vagrant

group_vars_all

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

#workuser_name: "vagrant"

#primary_domain_ipv4: "mizunashi-work.vagrant"
#primary_domain_ipv6: "mizunashi-work.vagrant"
#private_domain: "mizunashi-local.private"

#internal_ipv6_prefix64: "fde4:8dba:82e1:1006"
#internal_ipv6_subnet: "\(#internal_ipv6_prefix64)::/64"

#internal_host_entries: {
  internal001: {
    host: "internal.\(#primary_domain_ipv4)"

    public_ipv4_address: "192.168.61.34"
    public_ipv4_gateway: "10.0.2.2"
    public_ipv4_netmask: "255.255.255.0"

    public_ipv6_address: "fde4:8dba:82e1:1005::34"
    public_ipv6_netmask: "64"

    internal_host: "internal001.\(#private_domain)"
    internal_ipv6_address: "\(#internal_ipv6_prefix64)::1001"
  }
}

#public_host_entries: {
  public001: {
    host: "public.\(#primary_domain_ipv4)"

    public_ipv4_address: "192.168.61.33"
    public_ipv4_gateway: "10.0.2.2"
    public_ipv4_netmask: "255.255.255.0"

    public_ipv6_address: "fde4:8dba:82e1:1005::33"
    public_ipv6_netmask: "64"

    internal_host: "public001.\(#private_domain)"
    internal_ipv6_address: "\(#internal_ipv6_prefix64)::1002"
  }
}

#host_entries: {
  for host, entry in #internal_host_entries {
    "\(host)": entry
  }
  for host, entry in #public_host_entries {
    "\(host)": entry
  }
}

#dns_resolver_primary_ipv4: "4.2.2.1"
#dns_resolver_primary_ipv6: "2001:4860:4860::8844"
#dns_resolvers_secondary: [
  "4.2.2.2",
]

#private_acme_challenge_hostname: "acme.\(#private_domain)"
#private_acme_challenge_url:  "https://\(#private_acme_challenge_hostname):\(#private_acme_server_https_port)/acme/local/directory"

#mastodon_hostname: "mstdn-local.mizunashi.work"
#www_hostname: "www-local.mizunashi.work"
#root_hostname: "local.mizunashi.work"

#minio_server_hostname: "minio.\(#private_domain)"
#minio_server_url: "https://\(#minio_server_hostname):\(#minio_server_https_port)"

#elasticsearch_hostname: "elasticsearch.\(#private_domain)"

#account_email: "\(#workuser_name)@localhost"
#notification_email: "\(#workuser_name)@localhost"

#local_proxy_jobs: prometheus: {
  name: "prometheus"
  password: #local_proxy_password
}
#local_proxy_jobs: grafana: {
  name: "grafana"
  password: #local_proxy_password
}
#local_proxy_jobs: node: {
  name: "node"
  password: #local_proxy_password
}
#local_proxy_jobs: nginx: {
  name: "nginx"
  password: #local_proxy_password
}
#local_proxy_jobs: redis: {
  name: "redis"
  password: #local_proxy_password
}
#local_proxy_jobs: postgres: {
  name: "postgres"
  password: #local_proxy_password
}
#local_proxy_jobs: statsd: {
  name: "statsd"
  password: #local_proxy_password
}
#local_proxy_jobs: caddy: {
  name: "caddy"
  password: #local_proxy_password
}
#local_proxy_jobs: minio: {
  name: "minio"
  password: #local_proxy_password
}
#local_proxy_jobs: elasticsearch: {
  name: "elasticsearch"
  password: #local_proxy_password
}
#local_proxy_jobs: fluent_bit: {
  name: "fluent-bit"
  password: #local_proxy_password
}
#local_proxy_jobs: mastodon_streaming: {
  name: "mastodon-streaming"
  password: #local_proxy_password
}

#local_proxy_password: "__ansible_vault": """
$ANSIBLE_VAULT;1.1;AES256
36633436613662373337636363313865306635333737366632303932333939303065626239323236
3335333362613132666562323332623731646633366139610a666338373236393837636339323038
33383462353635313337616537636239636430386165363664363435383631353962623135643231
3965663439336432330a356139363465663438303430313733656431663232626433356136663632
6164
"""

#postgres_backup_config: {
  access_key: "postgres-backup"
  secret_key: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  62356637313731376334383336616332393936306231343930343163666366613062643330323366
  3234626231666439646234653165393839306439326261370a346332316463623539623639623633
  61656566353831363366653531383530663564633661363361306134346338643761386136316565
  3033656435353263620a356264383762373763313464363235393734346261333666346234653832
  3666
  """
  bucket: "postgres-backup"
}

ansible_connection: "ssh"
ansible_port: #ssh_port
ansible_user: #workuser_name

workuser_setup_username: #workuser_name
workuser_setup_home_directory: "/home/\(workuser_setup_username)"
workuser_setup_ssh_authorized_keys: [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkqfF4qMFhr2fg+Yw3WLIqaRLqYzkCjWy2fdF4eQ5LG mizunashi-work-playbook"
]

ca_certs_private_root_ca_certs: "private_root_ca_2023": {
  cert: ca_vars.root_ca_certificate
}

network_public_iface: "eth1"

network_internal_iface: "eth2"
network_internal_ipv6_netmask: "64"

systemd_resolved_primary_dns: #dns_resolver_primary_ipv4
systemd_resolved_fallback_dns: [
  #dns_resolver_primary_ipv6,
  for entry in #dns_resolvers_secondary {
    entry
  },
]

for _, entry in #host_entries {
  base_hosts_to_ips: "\(entry.internal_host)": entry.internal_ipv6_address
}
base_hosts_to_ips: "\(#private_acme_challenge_hostname)": #host_entries.internal001.internal_ipv6_address
base_hosts_to_ips: "\(#minio_server_hostname)": #host_entries.internal001.internal_ipv6_address
base_hosts_to_ips: "\(#elasticsearch_hostname)": #host_entries.internal001.internal_ipv6_address

nftables_accept_tcp_ports: "\(#ssh_port)": {}
nftables_accept_ports_with_iif: "internal_local_proxy": {
  iif: network_internal_iface
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
  oif: network_public_iface
  ip_cond: {
    all: true
  }
  proto_cond: {
    tcp_sports: [
      #ssh_port,
    ]
  }
}
nftables_outbound_logging_filter_entries: "internal_network_for_all": {
  oif: network_internal_iface
  ip_cond: {
    ipv6_daddrs: [
      #internal_ipv6_subnet,
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

sudo_mail_address: #notification_email

apticron_notification_email: #notification_email
certbot_acme_notification_email: #notification_email

nginx_resolver: #dns_resolver_primary_ipv4

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

fluent_bit_output_elasticsearch_user_name: "logstash_upload"
fluent_bit_output_elasticsearch_user_password: "__ansible_vault": """
$ANSIBLE_VAULT;1.1;AES256
62356637313731376334383336616332393936306231343930343163666366613062643330323366
3234626231666439646234653165393839306439326261370a346332316463623539623639623633
61656566353831363366653531383530663564633661363361306134346338643761386136316565
3033656435353263620a356264383762373763313464363235393734346261333666346234653832
3666
"""

fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_auth_log_tag)": {}
fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_kern_log_tag)": {}
fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_nftables_filter_log_tag)": {}
fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_nftables_output_log_tag)": {}
fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_exim4_mainlog_tag)": {}
fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_fail2ban_log_tag)": {}
fluent_bit_output_elasticsearch_entries: "\(fluent_bit_input_nginx_log_error_tag)": {}
fluent_bit_output_elasticsearch_entries: "\(#fluent_bit_input_nginx_log_access_http_redirector_tag)": {}
