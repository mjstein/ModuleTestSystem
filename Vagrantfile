$script = <<SCRIPT
sudo yum install epel-release -y
sudo yum install puppet vim -y
SCRIPT
domain = 'kubernetes.com'
boxname = 'centos/7'

puppet_nodes = [
  {:hostname => 'kube-master',  :ip => '173.16.32.11', :box => boxname, :ram => 2048},
  {:hostname => 'kube-minion1',  :ip => '173.16.32.12', :box => boxname, :ram => 1024},
  {:hostname => 'kube-minion2',  :ip => '173.16.32.13', :box => boxname, :ram => 1024},
]

Vagrant.configure("2") do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.hostname = node[:hostname] + '.' + domain
      node_config.vm.network :private_network, ip: node[:ip]
      #node_config.ssh.forward_x11 = true

      if node[:fwdhost]
        node_config.vm.network :forwarded_port, guest: node[:fwdguest], host: node[:fwdhost]
      end
      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--name', node[:hostname],
          '--memory', memory.to_s
        ]
      end
      node_config.vm.provision "shell", inline: $script
    end
  end
end


