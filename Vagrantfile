require 'yaml'

cluster_config = YAML.load_file('cluster-config.yml')

Vagrant.configure("2") do |config|

    cluster_token = cluster_config.fetch("master").fetch("token")
    master_config = cluster_config.fetch("master")
    
    hosts_box = "ubuntu/focal64"
    network_base_ip = "192.168.99"
    master_ip = "#{network_base_ip}.100"
    node_name_pattern = "node%02d"
    
    config.vm.define "master" do |master|
        master.vm.box = hosts_box
        master.vm.boot_timeout = 600
        master.vm.provider :virtualbox do |v|
            v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            v.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new('1.8.0')
            v.linked_clone = true
            v.cpus = master_config.fetch("cpus")
            v.memory = master_config.fetch("memory")
            v.name = "master"
        end
        master.vm.network "private_network", ip: master_ip
        master.vm.hostname = "kube-master"
        master.vm.provision "shell", path: "configure-host.sh", privileged: false, env: {"MACHINE_IP" => master_ip}
        master.vm.provision "shell", path: "configure-master.sh", privileged: false, env: {"K8S_TOKEN" => cluster_token, "MACHINE_IP" => master_ip, "KUBE_INIT_EXTRA_ARGS" => "--pod-network-cidr=#{network_base_ip}.0/16"}

    end

    nodes_config = cluster_config.fetch("nodes")
    (1 .. nodes_config.fetch('count')).each do |i|
        nodename = node_name_pattern % i
        config.vm.define nodename do |node|
            node.vm.box = hosts_box
            node.vm.boot_timeout = 420
            node.vm.provider :virtualbox do |v|
                v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                v.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new('1.8.0')
                v.linked_clone = true
                v.cpus = nodes_config.fetch("cpus")
                v.memory = nodes_config.fetch("memory")
                v.name = nodename
            end
            final_ip = 100 + i
            machine_ip = "#{network_base_ip}.#{final_ip}"
            node.vm.network "private_network", ip: machine_ip
            node.vm.hostname = nodename
            node.vm.provision "shell", path: "configure-host.sh", privileged: false, env: {"MACHINE_IP" => machine_ip}
            node.vm.provision "shell", path: "join-node.sh", privileged: false, env: {"K8S_TOKEN" => cluster_token, "MASTER_IP" => master_ip}
        end
    end

end
