# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'erb'
require 'ostruct'
require 'yaml'

# Parse a given erb template with a hash of values
def parse(from, to: '', hash: {})
  content = File.read(from)
  template = ERB.new(content)
  if to.nil? || to.empty?
      to = from.gsub(/\.erb$/, '')
  end
  content = template.result(OpenStruct.new(hash).instance_eval { binding })
  File.write(to, content)
end

settings_file_name = 'vagrant.yaml'

unless File::readable?(settings_file_name)
    raise "Can't read file `#{settings_file_name}`"
end

settings = YAML.load_file settings_file_name

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  # https://developer.hashicorp.com/vagrant/docs/vagrantfile

  # The hostname the machine should have. Defaults to nil. If nil, Vagrant will
  # not manage the hostname. If set to a string, the hostname will be set on
  # boot. If set, Vagrant will update /etc/hosts on the guest with the
  # configured hostname.
  config.vm.hostname = "#{settings['vm']['hostname']}"

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "#{settings['vm']['box']['name']}"
  config.vm.box_version = "#{settings['vm']['box']['version']}"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # The settings within `config.ssh` relate to configuring how Vagrant will
  # access your machine over SSH. As with most Vagrant settings, the defaults
  # are typically fine, but you can fine tune whatever you would like.
  # @see https://stackoverflow.com/a/78189947
  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'
  config.ssh.insert_key = 'true'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "#{settings['vm']['network']['ip']}"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "dockerfiles", "/home/vagrant/dockerfiles"
  config.vm.synced_folder "sql", "/home/vagrant/sql"
  config.vm.synced_folder "wordpress", "/home/vagrant/wordpress"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "#{settings['vm']['provider']['memory']}"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "bootstrap", type: "shell" do |s|
    s.path = "provision/bootstrap.sh"
  end

  parse('dockerfiles/frankenphp/Caddyfile.erb', hash: {
    :domain => "#{settings['provision']['domain']['local']}",
  })

  config.vm.provision "images", type: "shell" do |s|
    s.path = "provision/images.sh"
  end

  config.vm.provision "database", type: "shell" do |s|
    s.path = "provision/database.sh"
    s.env = {
      :DATABASE_DDBB => "#{settings['provision']['database']['ddbb_name']}",
      :DATABASE_PASS => "#{settings['provision']['database']['user_pass']}",
      :DATABASE_ROOT => "#{settings['provision']['database']['root_pass']}",
      :DATABASE_USER => "#{settings['provision']['database']['user_name']}",
      :DOMAIN_NEW => "#{settings['provision']['domain']['local']}",
      :DOMAIN_OLD => "#{settings['provision']['domain']['production']}",
      :PREFIX => "#{settings['provision']['database']['prefix']}",
    }
  end
end
