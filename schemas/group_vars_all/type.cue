package group_vars_all

import "mizunashi.work/pkg/roles/base"
import "mizunashi.work/pkg/roles/network"
import "mizunashi.work/pkg/roles/workuser_setup"
import "mizunashi.work/pkg/roles/private_root_ca"
import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/apticron"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"
import "mizunashi.work/pkg/roles/certbot"
import "mizunashi.work/pkg/roles/node_exporter"
import "mizunashi.work/pkg/roles/nginx"
import "mizunashi.work/pkg/roles/nginx_exporter"
import "mizunashi.work/pkg/roles/nginx_site_local_proxy"
import "mizunashi.work/pkg/roles/nginx_site_http_redirector"

base
network
workuser_setup
private_root_ca
openssh_server
nftables
fail2ban
node_exporter
apticron
certbot
nginx
nginx_exporter
nginx_site_http_redirector
nginx_site_local_proxy
