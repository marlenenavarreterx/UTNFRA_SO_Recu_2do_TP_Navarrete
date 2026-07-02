#!/bin/bash

# Particionado no interactivo (limpio para script)
echo -e "n\np\n1\n\n+512M\nt\n82\nn\np\n2\n\n\nt\n2\n8e\nw" | sudo fdisk /dev/sdd
echo -e "n\np\n1\n\n\nt\n8e\nw" | sudo fdisk /dev/sdc

# LVM
sudo pvcreate /dev/sdc1 /dev/sdd2
sudo vgcreate vg_datos /dev/sdc1 /dev/sdd2
sudo lvcreate -L 10M -n lv_docker vg_datos
sudo lvcreate -L 1.5G -n lv_multimedia vg_datos

# Formateo
sudo mkfs.ext4 /dev/vg_datos/lv_docker
sudo mkfs.ext4 /dev/vg_datos/lv_multimedia

# Swap
sudo mkswap /dev/sdd1
sudo swapon /dev/sdd1

# Montaje
sudo mkdir -p /var/lib/docker /multimedia
sudo mount /dev/vg_datos/lv_docker /var/lib/docker
sudo mount /dev/vg_datos/lv_multimedia /multimedia

# Persistencia en fstab
echo "/dev/vg_datos/lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/vg_datos/lv_multimedia /multimedia ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/sdd1 none swap sw 0 0" | sudo tee -a /etc/fstab
