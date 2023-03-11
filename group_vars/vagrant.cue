import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"

#Schema: fail2ban
#Schema: nftables
#Schema: openssh_server

#Schema & {
  openssh_server_listen_port: 22
  nftables_accept_tcp_ports: [22, 80, 443]
}
