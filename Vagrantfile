#!/usr/bin/env ruby

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.synced_folder ".", "/vagrant/atlas"
  config.ssh.extra_args = ["-t", "cd /vagrant/atlas; bash --login"]

  config.vm.disk :disk, size: "20GB", primary: true

  config.vm.provision :docker

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update -y && apt-get install make sqlite3 -y
    cd /vagrant/atlas && make start
  SHELL

  config.vm.hostname = "atlas"

  config.vm.network "forwarded_port",
    guest: 3000,
    host: 3000,
    host_ip: "127.0.0.1",
    id: "gitea"

  config.vm.network "forwarded_port",
    guest: 222,
    host: 222,
    host_ip: "127.0.0.1",
    id: "gitea-git"

  config.vm.network "forwarded_port",
    guest: 8096,
    host: 8096,
    host_ip: "127.0.0.1",
    id: "jellyfin"

  config.vm.network "forwarded_port",
    guest: 7359,
    host: 7359,
    host_ip: "127.0.0.1",
    id: "jellyfin-udp"
end
