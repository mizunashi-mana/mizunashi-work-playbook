internal_node_name = "internal-mizunashi-work"
public_node_name = "public-mizunashi-work"

vault_password_file = "assets/vagrant_vault_password"
ansible_arguments = [
  "--diff"
]

ansible_groups = {
  "vagrant" => [public_node_name, internal_node_name],
  "public_vagrant" => [public_node_name],
  "internal_vagrant" => [internal_node_name],
  "public" => [public_node_name],
  "internal" => [internal_node_name]
}

eth2_private_network_name = "mizunashi-work-playbook-net-local"
eth3_nat_network_name = "mizunashi-work-playbook-net-nat"

Vagrant.configure(2) do |config|
  config.vm.define internal_node_name do |node|
    node.vm.box = "generic/debian11"
    node.vm.hostname = "internal.mizunashi-work.vagrant"
    node.vm.network :private_network, ip: "192.168.61.34"
    node.vm.network :private_network,
      auto_config: false,
      virtualbox__intnet: eth2_private_network_name

    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--nic4", "natnetwork"]
      vb.customize ["modifyvm", :id, "--nat-network4", eth3_nat_network_name]
    end
  end
  config.vm.define public_node_name do |node|
    node.vm.box = "generic/debian11"
    node.vm.hostname = "public.mizunashi-work.vagrant"
    node.vm.network :private_network, ip: "192.168.61.33"
    node.vm.network :private_network,
      auto_config: false,
      virtualbox__intnet: eth2_private_network_name
  
    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--nic4", "natnetwork"]
      vb.customize ["modifyvm", :id, "--nat-network4", eth3_nat_network_name]
    end
  end

  config.vm.provision "shell", inline: <<~SHELL
    set -exuo pipefail
    ETH3_IPV4_ADDR="$(ip -family inet -o addr show dev eth0 | sed -E 's|^.* inet 10\\.0\\.2\\.([0-9]+)/24 brd .*$|10.100.10.\\1|')"
    echo "allow-hotplug eth3\niface eth3 inet static\n  address $ETH3_IPV4_ADDR\n  netmask 255.255.255.0\n" > /etc/network/interfaces.d/natnetwork4.conf
  SHELL

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vv"
    ansible.vault_password_file = vault_password_file
    ansible.raw_arguments = ansible_arguments
    ansible.groups = ansible_groups
    ansible.playbook = "playbook-base.yml"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vv"
    ansible.vault_password_file = vault_password_file
    ansible.raw_arguments = ansible_arguments
    ansible.groups = ansible_groups
    ansible.playbook = "playbook-all.yml"
  end
end
