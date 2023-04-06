package vagrant

import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/roles/base"
import "mizunashi.work/pkg/roles/workuser_setup"
import "mizunashi.work/pkg/roles/private_root_ca"
import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/apticron"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"
import "mizunashi.work/pkg/roles/exim"
import "mizunashi.work/pkg/roles/node_exporter"
import "mizunashi.work/pkg/roles/nginx"
import "mizunashi.work/pkg/roles/nginx_exporter"
import "mizunashi.work/pkg/roles/nginx_site_local_proxy"
import "mizunashi.work/pkg/roles/nginx_site_http_redirector"

#ssh_port: 22
#http_port: 80
#local_proxy_https_port: nginx_site_local_proxy.nginx_site_local_proxy_listen_port
#node_exporter_http_port: node_exporter.node_exporter_listen_port
#nginx_exporter_http_port: nginx_exporter.nginx_exporter_listen_port
#acme_server_https_port: 6100

#internal_iface: "eth2"

#internal_host_entries: {
  internal001: {
    internal_ip: "192.168.62.34"
    internal_host: "internal001.mizunashi-local.private"
    host: "internal.mizunashi-work.vagrant"
  }
}

#public_host_entries: {
  public001: {
    internal_ip: "192.168.62.33"
    internal_host: "public001.mizunashi-local.private"
    host: "public.mizunashi-work.vagrant"
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

#local_proxy_password:
  "__ansible_vault":
    """
    $ANSIBLE_VAULT;1.1;AES256
    36633436613662373337636363313865306635333737366632303932333939303065626239323236
    3335333362613132666562323332623731646633366139610a666338373236393837636339323038
    33383462353635313337616537636239636430386165363664363435383631353962623135643231
    3965663439336432330a356139363465663438303430313733656431663232626433356136663632
    6164
    """

#internal_dns_resolver: #internal_host_entries.internal001.internal_ip

#notification_email: "root@localhost"

base
workuser_setup
private_root_ca
openssh_server
nftables
fail2ban
node_exporter
exim
apticron
nginx
nginx_exporter
nginx_site_http_redirector
nginx_site_local_proxy

base_internal_dns_ip: #internal_dns_resolver

workuser_setup_username: "vagrant"
workuser_setup_home_directory: "/home/\(workuser_setup_username)"
workuser_setup_ssh_authorized_keys: [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkqfF4qMFhr2fg+Yw3WLIqaRLqYzkCjWy2fdF4eQ5LG mizunashi-work-playbook"
]

private_root_ca_certificate: private_ca_vagrant.root_ca_certificate

nftables_accept_tcp_ports: [#ssh_port, ...uint]
nftables_accept_ports_with_iif: "internal_local_proxy": {
  iif: #internal_iface
  tcp_ports: [
    #local_proxy_https_port
  ]
}

openssh_server_listen_port: #ssh_port

apticron_notification_email: #notification_email

nginx_resolver: #internal_dns_resolver

nginx_site_http_redirector_listen_port: #http_port

nginx_site_local_proxy_listen_port: #local_proxy_https_port
nginx_site_local_proxy_email: #notification_email
nginx_site_local_proxy_acme_challenge_url: "https://\(#internal_host_entries.internal001.internal_host):\(#acme_server_https_port)/acme/local/directory"

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
