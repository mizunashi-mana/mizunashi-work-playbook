Vagrant.configure(2) do |config|
  config.vm.define "mizunashi-work-primary" do |node|
    node.vm.box = "generic/debian11"
    node.vm.hostname = "mizunashi-work-primary"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vv"
    ansible.raw_arguments = ["--diff"]
    ansible.playbook = "playbook-site.yml"
    ansible.groups = {
      "vagrant" => ["mizunashi-work-primary"]
    }
  end
end
