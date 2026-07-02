#!/bin/bash
TIMESTAMP=$(date +%Y%m%d)
PUNTO="A"

# ---
clear
echo "Se espera ver: "
echo "Discos de 2G 1G 1G"
echo "vg_Datos -> lv_docker=10MB"
echo "vg_Datos -> lv_multimedia=1.5G"
echo "Particion swap 512M"
echo "1 disco de 1GB entero para defensa"
echo 

# --- Particiones
echo "lsblk -f"
lsblk -f
echo
read -p "Enter para continuar... " PAUSA
echo

# --- LVM
echo "pvs - vgs - lvs "
sudo pvs
echo
sudo vgs
echo
sudo lvs
echo

# --- SWAP
echo "swap"
free -h 
swapon -s 

# --- Montaje
echo
echo "df -h"
df -h
echo
read -p "Enter para continuar... " PAUSA
echo

# --- Comandos usados:
echo
echo "cat $HOME/RTA_Examen_${TIMESTAMP}/Punto_${PUNTO}.sh"
echo
cat $HOME/RTA_Examen_${TIMESTAMP}/Punto_${PUNTO}.sh
echo "-------------------------------------------------------------"
echo
