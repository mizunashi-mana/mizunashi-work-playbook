package vagrant

import "mizunashi.work/pkg/roles/base"
import "mizunashi.work/pkg/roles/workuser_setup"
import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"
import "mizunashi.work/pkg/roles/exim"
import "mizunashi.work/pkg/roles/node_exporter"

#ssh_port: 22

base
workuser_setup
openssh_server
nftables
fail2ban
node_exporter
exim

workuser_setup_username: "vagrant"
workuser_setup_home_directory: "/home/vagrant"
workuser_setup_ssh_authorized_keys: [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkqfF4qMFhr2fg+Yw3WLIqaRLqYzkCjWy2fdF4eQ5LG workuser@vagrant"
]

openssh_server_listen_port: #ssh_port
