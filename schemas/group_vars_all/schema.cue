package group_vars_all

import "mizunashi.work/pkg/roles/base"
import "mizunashi.work/pkg/roles/ca_certs"
import "mizunashi.work/pkg/roles/network"
import "mizunashi.work/pkg/roles/sudo"
import "mizunashi.work/pkg/roles/systemd_resolved"
import "mizunashi.work/pkg/roles/workuser_setup"
import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/exim"
import "mizunashi.work/pkg/roles/apticron"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"
import "mizunashi.work/pkg/roles/certbot"
import "mizunashi.work/pkg/roles/node_exporter"
import "mizunashi.work/pkg/roles/fluentd"
import "mizunashi.work/pkg/roles/fluentd_input_auth_log"
import "mizunashi.work/pkg/roles/fluentd_input_nginx_log"
import "mizunashi.work/pkg/roles/fluentd_output_elasticsearch"
import "mizunashi.work/pkg/roles/nginx"
import "mizunashi.work/pkg/roles/nginx_exporter"
import "mizunashi.work/pkg/roles/nginx_site_local_proxy"
import "mizunashi.work/pkg/roles/nginx_site_http_redirector"

base
ca_certs
network
sudo
systemd_resolved
workuser_setup
openssh_server
nftables
fail2ban
node_exporter
exim
apticron
certbot
fluentd
fluentd_input_auth_log
fluentd_input_nginx_log
fluentd_output_elasticsearch
nginx
nginx_exporter
nginx_site_http_redirector
nginx_site_local_proxy
