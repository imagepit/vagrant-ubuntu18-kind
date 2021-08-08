Vagrant.configure("2") do |config|
    config.vm.box = "imagepit/ubuntu18-kind"
    config.vm.box_version = "1.0.0"
    config.vm.network "private_network", ip: "192.168.33.11"
    config.vm.synced_folder ".", "/vagrant", create: true, owner: "vagrant", group: "vagrant"
    config.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 2
    end
end