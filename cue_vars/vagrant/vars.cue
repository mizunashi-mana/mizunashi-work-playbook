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
#private_acme_server_https_port: 6100

#workuser_name: "vagrant"

#primary_domain: "mizunashi-work.vagrant"
#private_domain: "mizunashi-local.private"

#internal_host_entries: {
  internal001: {
    host: "internal.\(#primary_domain)"
    public_ipv4: "192.168.61.34"
    public_ipv6: "fde4:8dba:82e1:1005:1"
    internal_host: "internal001.\(#private_domain)"
    internal_ipv4: "192.168.62.1"
  }
}

#public_host_entries: {
  public001: {
    host: "public.\(#primary_domain)"
    public_ipv4: "192.168.61.35"
    public_ipv6: "fde4:8dba:82e1:1005:2"
    internal_host: "public001.\(#private_domain)"
    internal_ipv4: "192.168.62.2"
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

#public_dns_resolver_ipv4: "4.2.2.1"
#public_dns_resolver_ipv6: "2001:4860:4860::8844"
#public_dns_resolvers: [#public_dns_resolver_ipv4, #public_dns_resolver_ipv6]
#internal_dns_resolver: #host_entries.internal001.internal_ipv4

#private_acme_challenge_hostname: "acme.\(#private_domain)"
#private_acme_challenge_url:  "https://\(#private_acme_challenge_hostname):\(#private_acme_server_https_port)/acme/local/directory"

#mastodon_hostname: "mstdn-local.mizunashi.work"
#www_hostname: "www-local.mizunashi.work"

#minio_server_hostname: "minio.\(#private_domain)"

#account_email: "\(#workuser_name)@localhost"
#notification_email: "\(#workuser_name)@localhost"

#local_proxy_password: {
  "__ansible_vault":
    """
    $ANSIBLE_VAULT;1.1;AES256
    36633436613662373337636363313865306635333737366632303932333939303065626239323236
    3335333362613132666562323332623731646633366139610a666338373236393837636339323038
    33383462353635313337616537636239636430386165363664363435383631353962623135643231
    3965663439336432330a356139363465663438303430313733656431663232626433356136663632
    6164
    """
}

ansible_connection: "ssh"
ansible_port: #ssh_port
ansible_user: #workuser_name

workuser_setup_username: #workuser_name
workuser_setup_home_directory: "/home/\(workuser_setup_username)"
workuser_setup_ssh_authorized_keys: [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkqfF4qMFhr2fg+Yw3WLIqaRLqYzkCjWy2fdF4eQ5LG mizunashi-work-playbook"
]

private_root_ca_certificate: ca_vars.root_ca_certificate

network_public_iface: "eth1"
network_public_ipv4_netmask: "255.255.255.0"
network_public_ipv4_nameserver: #public_dns_resolver_ipv4
network_public_ipv4_search: #primary_domain
network_public_ipv6_netmask: "64"
network_public_ipv6_nameserver: #public_dns_resolver_ipv6
network_public_ipv6_search: #primary_domain

network_internal_iface: "eth2"
network_internal_ipv4_netmask: "255.255.255.0"
network_internal_ipv4_nameserver: #internal_dns_resolver
network_internal_ipv4_search: #private_domain

systemd_resolved_internal_dns: #internal_dns_resolver
systemd_resolved_fallback_dns: #public_dns_resolvers

nftables_accept_tcp_ports: [#ssh_port, ...uint]
nftables_accept_ports_with_iif: "internal_local_proxy": {
  iif: network_internal_iface
  tcp_ports: [
    #local_proxy_https_port
  ]
}

openssh_server_listen_port: #ssh_port

sudo_mail_address: #notification_email

exim_smarthost_hostname: "smtp-relay-dummy.localhost"
exim_smarthost_port: 587
exim_smarthost_auth_userid: "dummy"
exim_smarthost_auth_password: {
  "__ansible_vault":
    """
    $ANSIBLE_VAULT;1.1;AES256
    35373731313932333565623162306266656562313032636530313430306637373833303333386662
    3233653565346164623265643865336439383666323261620a626339396333303761393036373839
    34616239366634346132623737633461653732653465316163316234643034666134643530306634
    6162646332396662340a386361643965396431643536303461336533333762383735613535373238
    3264
    """
}

apticron_notification_email: #notification_email
certbot_acme_notification_email: #notification_email

nginx_resolver: #internal_dns_resolver

nginx_site_http_redirector_listen_port: #http_port

nginx_site_local_proxy_listen_port: #local_proxy_https_port
nginx_site_local_proxy_acme_challenge_url: #private_acme_challenge_url

node_exporter_listen_port: #node_exporter_http_port
nginx_site_local_proxy_entries: "node": {
  upstream_port: #node_exporter_http_port
  auth_password: #local_proxy_password
}

nginx_exporter_listen_port: #nginx_exporter_http_port
nginx_site_local_proxy_entries: "nginx": {
  upstream_port: #nginx_exporter_http_port
  auth_password: #local_proxy_password
}
