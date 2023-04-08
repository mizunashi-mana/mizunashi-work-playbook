internal_node_name = "internal-mizunashi-work"
public_node_name = "public-mizunashi-work"

ansible_arguments = [
  "--diff",
  "--vault-password-file", "assets/vagrant_vault_password",
]

ansible_groups = {
  "vagrant" => [public_node_name, internal_node_name],
  "public_vagrant" => [public_node_name],
  "internal_vagrant" => [internal_node_name],
  "public" => [public_node_name],
  "internal" => [internal_node_name]
}

Vagrant.configure(2) do |config|
  config.vm.define internal_node_name do |node|
    node.vm.box = "generic/debian11"
    node.vm.hostname = "internal.mizunashi-work.vagrant"
    node.vm.network :private_network, ip: "192.168.61.34"
    node.vm.network :private_network,
      auto_config: false,
      virtualbox__intnet: "mizunashi-work-playbook-net"
  end
  config.vm.define public_node_name do |node|
    node.vm.box = "generic/debian11"
    node.vm.hostname = "public.mizunashi-work.vagrant"
    node.vm.network :private_network, ip: "192.168.61.33"
    node.vm.network :private_network,
      auto_config: false,
      virtualbox__intnet: "mizunashi-work-playbook-net"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vv"
    ansible.raw_arguments = ansible_arguments
    ansible.groups = ansible_groups
    ansible.playbook = "playbook-base.yml"
  end

  config.vm.provision :shell do |shell|
    shell.inline = <<-SHELL
      set -exuo pipefail
      if ! (ip address show dev eth2 | grep 192.168 >/dev/null); then
        echo 'Should `vagrant reload`.'
        exit 1
      fi
    SHELL
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vv"
    ansible.raw_arguments = ansible_arguments
    ansible.groups = ansible_groups
    ansible.playbook = "playbook-all.yml"
  end
end
