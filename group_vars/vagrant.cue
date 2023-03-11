import "mizunashi-work-playbook/pkg/openssh_server"

vars: openssh_server.#Schema
vars: {
  openssh_server_listen_port: 22
}
