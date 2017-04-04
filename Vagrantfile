# -*- mode: ruby -*-
# vi: set ft=ruby :

$init = <<SCRIPT
  # Upgrade rbenv to get latest ruby versions
  cd /home/vagrant/.rbenv/plugins/ruby-build && git pull

  # install ruby 2.3.0 (this is what we are using on Heroku)
  sudo -H -u vagrant bash -i -c 'rbenv install 2.3.0'
  sudo -H -u vagrant bash -i -c 'rbenv rehash'
  sudo -H -u vagrant bash -i -c 'rbenv global 2.3.0'
  sudo -H -u vagrant bash -i -c 'gem install bundler --no-ri --no-rdoc'

  # some missing dependencies
  sudo apt-get -y update
  sudo apt-get -y install postgresql postgresql-contrib libpq-dev libsqlite3-dev

  sudo -u postgres psql -c "create role dev_user with createdb login password 'myhomelibrary'";

  cd /vagrant
  bash -i -c bundler install

  bash -i -c 'rake db:create'
SCRIPT

$deploy = <<SCRIPT
  cd /vagrant
  bash -i -c bundler install

  bash -i -c 'rake db:migrate'

  sudo -H -u vagrant bash -i -c 'kill -9 `cat tmp/pids/server.pid`; rails server -d --binding=0.0.0.0'
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "lazygray/heroku-cedar-14"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
  end

  config.vm.provision :shell, run: "once", privileged: false, inline: $init
  config.vm.provision :shell, run: "always", privileged: false, inline: $deploy

  config.vm.network :forwarded_port, guest: 3000, host: 3000
end
