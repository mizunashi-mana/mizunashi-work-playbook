package vagrant

import "mizunashi.work/pkg/roles/base"
import "mizunashi.work/pkg/roles/workuser_setup"
import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/apticron"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"
import "mizunashi.work/pkg/roles/exim"
import "mizunashi.work/pkg/roles/node_exporter"

#ssh_port: 22

#hosts_entries: {
  public001: {
    ip: "192.168.61.33"
    exposed_host: "public001.mizunashi-local.private"
    host: "public.mizunashi-work.vagrant"
  }
  internal001: {
    ip: "192.168.61.34"
    exposed_host: "internal001.mizunashi-local.private"
    host: "internal.mizunashi-work.vagrant"
  }
}

base
workuser_setup
openssh_server
nftables
fail2ban
node_exporter
exim
apticron

workuser_setup_username: "vagrant"
workuser_setup_home_directory: "/home/\(workuser_setup_username)"
workuser_setup_ssh_authorized_keys: [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkqfF4qMFhr2fg+Yw3WLIqaRLqYzkCjWy2fdF4eQ5LG mizunashi-work-playbook"
]

openssh_server_listen_port: #ssh_port

apticron_notification_email: "root@localhost"
