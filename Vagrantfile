Vagrant.configure(2) do |config|
  config.vm.define "primary-mizunashi-work" do |node|
    node.vm.box = "generic/debian11"
    node.vm.hostname = "primary.mizunashi-work.vagrant"
    node.vm.network :private_network, ip: "192.168.61.33"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vv"
    ansible.raw_arguments = [
      "--diff",
      "--vault-password-file", "assets/vagrant_vault_password",
    ]
    ansible.playbook = "playbook-all.yml"
    ansible.groups = {
      "vagrant" => ["primary-mizunashi-work"]
    }
  end
end
