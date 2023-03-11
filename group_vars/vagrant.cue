import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"

#Schema: fail2ban
#Schema: nftables
#Schema: openssh_server

let ssh_port = 22

#Schema & {
  openssh_server_listen_port: ssh_port
  nftables_accept_tcp_ports: [
    ssh_port,
    80,
    443,
  ]
}
