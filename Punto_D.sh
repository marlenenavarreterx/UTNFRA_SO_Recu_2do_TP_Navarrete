#!/bin/bash
cd ~/UTN-FRA_SO_Examenes/202411/ansible/
sudo ansible-playbook -i "localhost," -c local site.yml
