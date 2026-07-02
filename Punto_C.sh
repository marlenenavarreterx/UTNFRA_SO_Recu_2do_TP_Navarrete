#!/bin/bash
cd ~/UTN-FRA_SO_Examenes/202411/docker/
sudo docker build -t marlenenavarreterx/web2-navarrete:latest .
sudo docker push marlenenavarreterx/web2-navarrete:latest
sudo docker compose up -d
