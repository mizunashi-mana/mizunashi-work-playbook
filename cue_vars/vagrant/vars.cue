package vagrant

import "mizunashi.work/pkg/roles/base"
import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"

#ssh_port: 22

base
openssh_server
nftables
fail2ban

base_workuser_name: "vagrant"

openssh_server_listen_port: #ssh_port
