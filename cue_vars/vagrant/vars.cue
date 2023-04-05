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

#ssh_port: 22
#local_proxy_https_port: nginx_site_local_proxy.nginx_site_local_proxy_listen_port
#node_exporter_http_port: node_exporter.node_exporter_listen_port
#nginx_exporter_http_port: nginx_exporter.nginx_exporter_listen_port

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
nginx_site_local_proxy

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

apticron_notification_email: "root@localhost"

nginx_resolver: "8.8.8.8"

nginx_site_local_proxy_server_name: "*.mizunashi-local.private"
nginx_site_local_proxy_listen_port: #local_proxy_https_port

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

nginx_site_local_proxy_certificate_fullchain:
  """
  -----BEGIN CERTIFICATE-----
  MIIEKzCCA7GgAwIBAgIBAjAKBggqhkjOPQQDBDB+MQswCQYDVQQGEwJKUDEOMAwG
  A1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxIDAeBgNV
  BAsMF21penVuYXNoaS13b3JrLXBsYXlib29rMR8wHQYDVQQDDBZWYWdyYW50IFBy
  aXZhdGUgVExTIENBMB4XDTIzMDQwMjA2MzIyNFoXDTI0MDQwMTA2MzIyNFowgYEx
  CzAJBgNVBAYTAkpQMQ4wDAYDVQQIDAVUb2t5bzEKMAgGA1UEBwwBLjEQMA4GA1UE
  CgwHUHJpdmF0ZTEgMB4GA1UECwwXbWl6dW5hc2hpLXdvcmstcGxheWJvb2sxIjAg
  BgNVBAMMGSoubWl6dW5hc2hpLWxvY2FsLnByaXZhdGUwdjAQBgcqhkjOPQIBBgUr
  gQQAIgNiAAS0kE/+VBJ6unAzpreXZMHuMMDy3u4zYNu6xk3+2taQiXIsVmRzEinR
  Yjpy5OPsljnS5fQCOjuvyJujt2aiCbX//Xv/MwFixV7hR5Pbb7BrjH5W8P1nsvoo
  PnggdHoVPMOjggH9MIIB+TAdBgNVHQ4EFgQUg2XzALQA89J/SZOH4FOzRiRmjUEw
  gasGA1UdIwSBozCBoIAUj2r7NZrNSC0OcPCSpJ5/h0ipH5ShgYSkgYEwfzELMAkG
  A1UEBhMCSlAxDjAMBgNVBAgMBVRva3lvMQowCAYDVQQHDAEuMRAwDgYDVQQKDAdQ
  cml2YXRlMSAwHgYDVQQLDBdtaXp1bmFzaGktd29yay1wbGF5Ym9vazEgMB4GA1UE
  AwwXVmFncmFudCBQcml2YXRlIFJvb3QgQ0GCAQEwCQYDVR0TBAIwADAOBgNVHQ8B
  Af8EBAMCB4AwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMIGIBggrBgEF
  BQcBAQR8MHowPAYIKwYBBQUHMAGGMGh0dHA6Ly9jYS1sb2NhbC5taXp1bmFzaGku
  d29yay9pbnRlckNBX1RMUy5vY3NwLzA6BggrBgEFBQcwAoYuaHR0cDovL2NhLWxv
  Y2FsLm1penVuYXNoaS53b3JrL2ludGVyQ0FfVExTLmNydDA/BgNVHR8EODA2MDSg
  MqAwhi5odHRwOi8vY2EtbG9jYWwubWl6dW5hc2hpLndvcmsvaW50ZXJDQV9UTFMu
  Y3JsMCQGA1UdEQQdMBuCGSoubWl6dW5hc2hpLWxvY2FsLnByaXZhdGUwCgYIKoZI
  zj0EAwQDaAAwZQIwUljHR/FrIX919Dy2uoviWSRHeT0l6bcLfI0sNL1DQQ+jli9p
  be7kYYR7gNl+BddJAjEAwyVXgQN7l6sA5yYc1gpp6rGtEC2L7trhdmN081vnHqil
  BsRe+pqoOu+zDWHnpu9o
  -----END CERTIFICATE-----
  """
nginx_site_local_proxy_certificate_chain: nginx_site_local_proxy_certificate_fullchain
nginx_site_local_proxy_certificate_privkey:
  "__ansible_vault":
    """
    $ANSIBLE_VAULT;1.1;AES256
    33636237373433333034626531333864316263313564393462656236386132393364316232646236
    6437353664396365626161666539646230343238306133640a623638653536643934626434373136
    37653839396238313332333861393134643035353035396432623938346564343238656534353135
    6434343836313732300a353436633434636239383238313962643336633163643562653633623362
    64313864343738366234653834386662646539633333663265343734396532353966323065656236
    35303439353961363038373432346135653438303130653038323365656137336366663934303266
    63626365336264393135666264373061303930306332656539396265373938663839633035336530
    38643361633037356465663839316435303237633334396330616262346562373139646134653065
    38666237356130393738643837663732363735386237353831393136623839643435393562633833
    62386630353332653033376462326438383264623864393535336231666661646565643033663636
    62656138336564306238633132366362353433303839656431313935316433353036303663366463
    36663266313232323536346161333465366530326438366463633936393334353838633162343836
    37396434633835333236626264323031663632353663323461316666313132656238636135663134
    32356236666264346166636137366366383535353364313461656637646131393430363236373266
    32633630303032366338383336303262366639353563643436363234316232363064373336643839
    65323464623031396137616130653333366365633535353131366332633333393439333262626337
    31333139356436393962393335306561376464633466333239656435343531666433363438383138
    63613130653463383532386362666535653938306533346261323461316339623566386465373165
    37346235383739353232346536636637396364326135636332326236653461383532346239346239
    32636630356462363133
    """
