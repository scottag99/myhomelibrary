# Dream Library
Connecting aspiring readers with donors to build a home library of books.

## Development Environment setup

Dream Library is a Ruby on Rails application deployed to a Heroku pipeline. Rails 5, Ruby 2.3.0, and Postgres 9.4(?) are the current framework versions.

### How to use vagrant to deploy Dream Library for development

First you need to have vagrant installed locally:

    https://www.vagrantup.com/downloads.html

Currently, only VirtualBox is configured for deployment. Vagrant can deploy to VMWare Fusion but the plugin requires a separate license so you need VirtualBox:

    https://www.virtualbox.org/wiki/Downloads

##### Application

The current Vagrantfile for the Dream Library app will setup an ubuntu VM that is similar to the Heroku stack that the application will run on

Vagrant will also setup port forwards for 3000 to local 3000 for access to remote app server

##### Deploy

The first time you deploy with Vagrant, an OS image is downloaded and provisioned. Future deploys will only update the application code.

1. Open terminal in same directory of this repo
1. Execute `vagrant up`. This will download the pre-configured linux VM for VirtualBox and run some initialization scripts.
1. Some users have seen the following error after running `vagrant up`:
```
==> default: Installing nokogiri 1.6.8 with native extensions
==> default: /tmp/vagrant-shell: line 2: 13699 Killed                  bash -i -c bundler install
==> default: bash: cannot set terminal process group (13694): Inappropriate ioctl for device
==> default: bash: no job control in this shell
==> default: rake aborted!
```
Execute `vagrant reload` and the initialization will complete.
1. In a browser, navigate to http://127.0.0.1:3000/ and the Dream Library splash page should render.
1. To execute new migrations, gems, or restart the server, run `vagrant reload`.

##### Helpful commands:

* `vagrant up` to start the environment.
* `vagrant ssh` to open up a terminal to the server
* `vagrant reload` to run `bundler`, `db:migrate`, and restart the rails server
