Vagrant.configure(2) do |config|
  config.vm.define "public-mizunashi-work" do |node|
    node.vm.box = "generic/debian11"
    node.vm.hostname = "public.mizunashi-work.vagrant"
    node.vm.network :private_network, ip: "192.168.61.33"
  end
  config.vm.define "internal-mizunashi-work" do |node|
    node.vm.box = "generic/debian11"
    node.vm.hostname = "internal.mizunashi-work.vagrant"
    node.vm.network :private_network, ip: "192.168.61.34"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vv"
    ansible.raw_arguments = [
      "--diff",
      "--vault-password-file", "assets/vagrant_vault_password",
    ]
    ansible.playbook = "playbook-all.yml"
    ansible.groups = {
      "vagrant" => ["public-mizunashi-work", "internal-mizunashi-work"],
      "public_vagrant" => ["public-mizunashi-work"],
      "internal_vagrant" => ["internal-mizunashi-work"],
      "public" => ["public-mizunashi-work"],
      "internal" => ["internal-mizunashi-work"]
    }
  end
end
