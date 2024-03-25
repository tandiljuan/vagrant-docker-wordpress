WordPress Local Development Environment
=======================================

Requirements
------------

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)
* [hostctl](https://github.com/guumaster/hostctl)


Create development environment
------------------------------

Copy Vagrant sample variables file and update it as needed.

```bash
# create variable file from sample
cp vagrant.yaml.sample vagrant.yaml
# edit file
vim vagrant.yaml
```

Clone WordPress site into the `wordpress` directory.

```bash
git clone https://.... wordpress
```

Move/copy database dump into `sql` directory.

```bash
mv /path/to/sql/file.sql sql/dump.sql
```

Create the Vagrant VM (and provision it).

```bash
vagrant up
```

Update local **hosts** (`/etc/hosts`) file.

```bash
sudo hostctl add domains PROFILE_NAME LOCAL_DOMAIN_NAME_FROM_VAGRANT_YAML --ip "IP_FROM_VAGRANT_YAML"
```

Login into Vagrant VM and start services

```bash
# ssh into vagrant vm
vagrant ssh
# Run all services
docker compose -f /home/vagrant/dockerfiles/docker-compose.yml up
```

Access the local site from the browser or check it with `curl`.

```bash
curl -v LOCAL_DOMAIN_NAME_FROM_VAGRANT_YAML
```

Run commands in the running services or stop/remove them.

```bash
# Exec a command inside a running service
docker compose -f /home/vagrant/dockerfiles/docker-compose.yml exec wordpress /bin/bash
# Remove running/stopped services
docker compose -f /home/vagrant/dockerfiles/docker-compose.yml rm --stop --force
```
