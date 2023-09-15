internal_node_name = "internal-mizunashi-work"
public_node_name = "public-mizunashi-work"

eth2_private_network_name = "mizunashi-work-playbook-net-local"
eth3_nat_network_name = "mizunashi-work-playbook-net-nat"

Vagrant.configure(2) do |config|
  #config.disksize.size = "50GB"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define internal_node_name do |node|
    node.vm.box = "debian/bookworm64"
    node.vm.hostname = "internal.mizunashi-work.vagrant"
    node.vm.network :private_network, ip: "192.168.61.34"
    node.vm.network :private_network,
      auto_config: false,
      virtualbox__intnet: eth2_private_network_name

    node.vm.provider :virtualbox do |vb|
      vb.memory = 2048
      vb.customize ["modifyvm", :id, "--nic4", "natnetwork"]
      vb.customize ["modifyvm", :id, "--nat-network4", eth3_nat_network_name]
    end
  end
  config.vm.define public_node_name do |node|
    node.vm.box = "debian/bookworm64"
    node.vm.hostname = "public.mizunashi-work.vagrant"
    node.vm.network :private_network, ip: "192.168.61.33"
    node.vm.network :private_network,
      auto_config: false,
      virtualbox__intnet: eth2_private_network_name

    node.vm.provider :virtualbox do |vb|
      vb.memory = 2048
      vb.customize ["modifyvm", :id, "--nic4", "natnetwork"]
      vb.customize ["modifyvm", :id, "--nat-network4", eth3_nat_network_name]
    end
  end

  config.vm.provision "shell", inline: <<~SHELL
    WORKUSER=vagrant
    SSH_PORT=22
    SSH_AUTHORIZED_KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkqfF4qMFhr2fg+Yw3WLIqaRLqYzkCjWy2fdF4eQ5LG mizunashi-work-playbook'

    #{File.read("./scripts/provision/init.bash")}

    mkdir -p /etc/netplan

    ETH3_IPV4_ADDR="$(ip -family inet -o addr show dev eth0 | sed -E 's|^.* inet 10\\.0\\.2\\.([0-9]+)/24 brd .*$|10.100.10.\\1|')"
    tee /etc/netplan/901_vagrant_natnet.yaml <<EOS
    network:
      version: 2
      renderer: networkd
      ethernets:
        eth3:
          addresses:
          - $ETH3_IPV4_ADDR/24
    EOS
    chmod 0600 /etc/netplan/901_vagrant_natnet.yaml

    tee /etc/network/interfaces <<EOS
    # interfaces(5) file used by ifup(8) and ifdown(8)
    # Include files from /etc/network/interfaces.d:
    source-directory /etc/network/interfaces.d

    # The loopback network interface
    auto lo
    iface lo inet loopback

    # The primary network interface
    allow-hotplug eth0
    iface eth0 inet dhcp
    EOS
    systemctl stop ifup@eth2
    systemctl stop ifup@eth3
    systemctl mask ifup@eth2
    systemctl mask ifup@eth3
    systemctl reset-failed
  SHELL
end
