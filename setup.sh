#! /bin/bash

sh $HOME/ansible-raspi-test/make_hosts.sh && ansible-playbook main.yml
